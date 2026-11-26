import os
import json
from flask import Flask, render_template, request, jsonify

app = Flask(__name__)

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_FILE = os.path.join(BASE_DIR, "data", "students.json")
MSSV = os.environ.get("MSSV", "2412111007")

def read_students():
    if not os.path.exists(DATA_FILE):
        return []
    with open(DATA_FILE, "r", encoding="utf-8") as f:
        return json.load(f)

def write_students(students):
    with open(DATA_FILE, "w", encoding="utf-8") as f:
        json.dump(students, f, ensure_ascii=False, indent=2)

@app.route("/", methods=["GET"])
def index():
    students = read_students()
    return render_template("index.html", students=students)

@app.route("/api/health", methods=["GET"])
def health():
    return jsonify({"status": "ok", "student": MSSV}), 200

@app.route("/api/students", methods=["GET"])
def get_students():
    students = read_students()
    lop = request.args.get("lop")
    if lop:
        students = [s for s in students if s.get("lop", "").lower() == lop.lower()]
    return jsonify(students), 200

@app.route("/api/students/<int:student_id>", methods=["GET"])
def get_student_by_id(student_id):
    students = read_students()
    for s in students:
        if s.get("id") == student_id:
            return jsonify(s), 200
    return jsonify({"error": "Not found"}), 404

@app.route("/api/students", methods=["POST"])
def add_student():
    data = request.get_json(silent=True)
    if not data:
        return jsonify({"error": "Invalid JSON"}), 400

    required_fields = ["mssv", "ho_ten", "lop", "diem"]
    for field in required_fields:
        if field not in data or data[field] == "":
            return jsonify({"error": f"Thieu truong {field}"}), 400

    try:
        diem = float(data["diem"])
    except (ValueError, TypeError):
        return jsonify({"error": "Diem phai la so"}), 400

    if diem < 0 or diem > 10:
        return jsonify({"error": "Diem phai nam trong khoang 0-10"}), 400

    students = read_students()
    new_id = max([s.get("id", 0) for s in students], default=0) + 1

    new_student = {
        "id": new_id,
        "mssv": str(data["mssv"]),
        "ho_ten": str(data["ho_ten"]),
        "lop": str(data["lop"]),
        "diem": diem
    }
    students.append(new_student)
    write_students(students)
    return jsonify(new_student), 201

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
