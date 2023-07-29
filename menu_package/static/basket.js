// Total hidden is there because total_para is a string that can't be turned into a number.
const total_para = document.getElementById("total");
const hidden_total = document.getElementById("total-hidden");
let current_total = Number(hidden_total.value);
hidden_total.remove();

window.addEventListener("DOMContentLoaded", attach_listeners);

function attach_listeners() {
    total = document.getElementById("total");

    function attach_button_listener(button, fetch_url, dish_id, num, output_element, parent_li) {
        const form_data = new URLSearchParams();
        form_data.append("dish_id", dish_id);
        form_data.append("number", num);

        button.addEventListener("click", async function() {
            const fetch_promise = await fetch(fetch_url, {
                method: "POST",
                body: form_data,
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                }
            })

            result = await fetch_promise.json();
            current_total += num * result["price"];
            total_para.innerHTML = `Total: £${current_total.toFixed(2)}`
            if (result["new_count"] <= 0) {
                parent_li.remove()
            } else {
                output_element.innerHTML = result["new_count"]
            }
        })
    }

    // make each menu item expandable
    const list_items = document.querySelectorAll("#results > li");
    for (const li of list_items) {
        const name = li.children[0];
        const details = li.children[1];
        
        name.addEventListener("click", () => {
            if (details.classList.contains("hidden")) {
                details.classList.remove("hidden");
            } else {
                details.classList.add("hidden");
            }
        });
    }

    // make the buttons on the menu item work
    const buttons_divs = document.querySelectorAll(".add-delete");

    for (let i = 0; i < buttons_divs.length; i++) {
        const div = buttons_divs[i];
        const li = list_items[i];
        const add_button = div.children[0];
        const delete_button = div.children[1];
        const span = div.children[2];
        const dish_id = div.children[3].value;
        div.children[3].remove();

        attach_button_listener(add_button, "/add_basket", dish_id, 1, span, li);
        attach_button_listener(delete_button, "/delete_basket", dish_id, -1, span, li);
    }
}