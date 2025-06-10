import sys
import threading
import time
import random
import requests
from flask import Flask, request, jsonify

app = Flask(__name__)

node_id = sys.argv[1]
peer_arg = sys.argv[2] if len(sys.argv) > 2 else ""
peers = peer_arg.split(",") if peer_arg else []

state = {
    "term": 0,
    "voted_for": None,
    "is_leader": False,
    "leader": None
}

lock = threading.Lock()

@app.route("/request_vote", methods=["POST"])
def request_vote():
    data = request.get_json()
    with lock:
        print(f"[{node_id}] Received vote request: {data}")
        if data["term"] > state["term"]:
            state["term"] = data["term"]
            state["voted_for"] = data["candidate_id"]
            print(f"[{node_id}] Voted for {data['candidate_id']} in term {data['term']}")
            return jsonify({"vote_granted": True, "term": state["term"]})
        else:
            print(f"[{node_id}] Rejected vote for {data['candidate_id']} in term {data['term']}")
            return jsonify({"vote_granted": False, "term": state["term"]})


def start_election():
    with lock:
        state["term"] += 1
        state["voted_for"] = node_id
        current_term = state["term"]
        votes = 1  # self vote

    print(f"[{node_id}] Starting election for term {current_term}")
    for peer in peers:
        try:
            response = requests.post(
                f"http://{peer}/request_vote",
                json={"term": current_term, "candidate_id": node_id},
                timeout=1
            )
            if response.ok and response.json().get("vote_granted"):
                votes += 1
                print(f"[{node_id}] Got vote from {peer}")
        except Exception as e:
            print(f"[{node_id}] Failed to contact {peer}: {e}")

    with lock:
        if votes > (len(peers) + 1) // 2:
            state["is_leader"] = True
            state["leader"] = node_id
            print(f"[{node_id}] 🎉 Elected leader for term {current_term} with {votes} votes")
        else:
            print(f"[{node_id}] Failed to win election (got {votes} votes)")


def election_timer():
    while True:
        timeout = random.randint(5, 10)
        print(f"[{node_id}] Waiting {timeout}s before next election attempt")
        time.sleep(timeout)

        with lock:
            if state["is_leader"]:
                continue

        start_election()


def run():
    print(f"[{node_id}] Starting node with peers: {peers}")
    threading.Thread(target=election_timer, daemon=True).start()
    app.run(host="0.0.0.0", port=5000)


if __name__ == "__main__":
    run()
