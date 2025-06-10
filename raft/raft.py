# raft.py
import sys
import threading
import time
import random
import requests
from flask import Flask, request, jsonify

app = Flask(__name__)

node_id = sys.argv[1]
peers = sys.argv[2].split(',')

state = {
    'term': 0,
    'leader': None,
    'voted_for': None,
    'is_leader': False
}

election_timeout = random.randint(5, 10)
last_heartbeat = time.time()

@app.route('/heartbeat', methods=['POST'])
def heartbeat():
    global last_heartbeat
    data = request.get_json()
    state['term'] = max(state['term'], data['term'])
    state['leader'] = data['leader']
    last_heartbeat = time.time()
    return jsonify({'status': 'ok'})

@app.route('/vote', methods=['POST'])
def vote():
    data = request.get_json()
    if state['voted_for'] in (None, data['candidate']):
        state['voted_for'] = data['candidate']
        return jsonify({'vote_granted': True})
    return jsonify({'vote_granted': False})

def send_heartbeat():
    while True:
        if state['is_leader']:
            for peer in peers:
                try:
                    requests.post(f'http://{peer}:5000/heartbeat', json={
                        'term': state['term'],
                        'leader': node_id
                    }, timeout=0.5)
                except:
                    pass
        time.sleep(2)

def election():
    global last_heartbeat
    while True:
        if time.time() - last_heartbeat > election_timeout:
            state['term'] += 1
            state['voted_for'] = node_id
            votes = 1
            for peer in peers:
                try:
                    r = requests.post(f'http://{peer}:5000/vote', json={
                        'term': state['term'],
                        'candidate': node_id
                    }, timeout=0.5)
                    if r.json().get('vote_granted'):
                        votes += 1
                except:
                    pass
            if votes > (len(peers) + 1) // 2:
                state['is_leader'] = True
                state['leader'] = node_id
                print(f"{node_id} is the new leader (term {state['term']})")

            last_heartbeat = time.time()
        time.sleep(1)

if __name__ == '__main__':
    threading.Thread(target=send_heartbeat, daemon=True).start()
    threading.Thread(target=election, daemon=True).start()
    app.run(host='0.0.0.0', port=5000)
