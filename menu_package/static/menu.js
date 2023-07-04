const search_bar = document.getElementById("menu-search");
const results_list = document.getElementById("results");

search_bar.addEventListener("input", async function() {
    results_list.innerHTML = "";
    const fetch_promise = await fetch(`/search?q=${search_bar.value}`);
    results_list.innerHTML = await fetch_promise.text();
})