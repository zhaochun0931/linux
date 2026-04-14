from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

# Initialize the API app
app = FastAPI()

# Our "database" (in-memory dictionary)
users_db = {
    1: {"id": 1, "name": "Alice", "role": "admin"},
    2: {"id": 2, "name": "Bob", "role": "user"}
}

# Define the structure of data we expect to receive (for POST and PUT)
class User(BaseModel):
    name: str
    role: str

# ---------------------------------------------------------
# THE REST ENDPOINTS
# ---------------------------------------------------------

# 1. GET (Read All)
@app.get("/users")
def get_all_users():
    return list(users_db.values())

# 2. GET (Read One)
@app.get("/users/{user_id}")
def get_user(user_id: int):
    if user_id not in users_db:
        raise HTTPException(status_code=404, detail="User not found")
    return users_db[user_id]

# 3. POST (Create)
@app.post("/users", status_code=201)
def create_user(user: User):
    new_id = max(users_db.keys()) + 1 if users_db else 1
    new_user = {"id": new_id, "name": user.name, "role": user.role}
    users_db[new_id] = new_user
    return new_user

# 4. PUT (Update)
@app.put("/users/{user_id}")
def update_user(user_id: int, user: User):
    if user_id not in users_db:
        raise HTTPException(status_code=404, detail="User not found")
    
    users_db[user_id] = {"id": user_id, "name": user.name, "role": user.role}
    return users_db[user_id]

# 5. DELETE (Remove)
@app.delete("/users/{user_id}")
def delete_user(user_id: int):
    if user_id not in users_db:
        raise HTTPException(status_code=404, detail="User not found")
    
    del users_db[user_id]
    return {"message": f"User {user_id} successfully deleted"}
