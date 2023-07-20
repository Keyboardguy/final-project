from flask import (
    Blueprint, render_template, request, session
)

from menu_package.db import get_db

bp = Blueprint('menu', __name__)

@bp.route("/", methods=["GET", "POST"])
def index():
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


@bp.route("/add", methods=["POST"])
def add_items():
    # TODO - I could make a generic function, since add_items and delete_items do nearly the same thing.
    # Note - The return type must be a string, dict, list, tuple with headers or status, Response instance, or WSGI callable, but it was a int.
    # So this function and the next one returns string representations of numbers.
    dish_id, num_to_add = get_form_results()
    if dish_id == None or num_to_add == None:
        return "Error"
    
    current_dishes = {}
    new_count = 0
    for id, value in session["current_dishes"].items():
        if id == dish_id:
            value += num_to_add
            new_count = value
        current_dishes[id] = value
        
    if new_count == 0:
        current_dishes[dish_id] = num_to_add
        new_count = num_to_add

    session["current_dishes"] = current_dishes
    return str(new_count)


@bp.route("/delete", methods=["POST"])
def delete_items():
    dish_id, num_to_add = get_form_results()
    if dish_id == None or num_to_add == None:
        return "Error"
    
    current_dishes = {}
    new_count = 0
    for id, value in session["current_dishes"].items():
        if id == dish_id:
            value += num_to_add
            if value <= 0:
                continue
            new_count = value
        current_dishes[id] = value
        
    session["current_dishes"] = current_dishes
    return str(new_count)


def get_form_results():
    if "current_dishes" not in session:
        session["current_dishes"] = {}

    dish_id = request.form.get("dish_id")
    num_to_add = request.form.get("number")

    try:
        dish_id = int(dish_id)
        num_to_add = int(num_to_add)
    except ValueError:
        return None, None
    
    return dish_id, num_to_add
    


