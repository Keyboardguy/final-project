from flask import (
    Blueprint, render_template, request, session
)

from menu_package.db import get_db

bp = Blueprint('menu', __name__)

@bp.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        dish_id = request.form.get("dish")
        if dish_id == None:
            return 0
        
        if "current_dishes" not in session:
            session["current_dishes"] = []
        
        for dish in session["current_dishes"]:
            if dish["id"] == dish_id:
                dish["count"] += 1
                return dish["count"]
        
        session["current_dishes"].append({"id": dish_id, "count": 1})
        return 1

    return render_template("menu/index.html")

@bp.route("/search")
def return_results():
    query = request.args.get("q")

    if query == None:
        return None
    
    query = f"%{query}%"

    db = get_db()
    dishes = db.execute(
        "SELECT *, type.name AS type_name"
        "  FROM dishes JOIN type ON type.id = dishes.type_id"
        " WHERE dishes.name LIKE ?"
        " ORDER BY menu_number ASC",
        (query,)
    ).fetchall()

    # https://stackoverflow.com/questions/3286525/return-sql-table-as-json-in-python
    # 2nd top answer, this guy is very cool.
    # i may use this if i ever need to return json.
    return render_template("menu/query.html", dishes=dishes)





