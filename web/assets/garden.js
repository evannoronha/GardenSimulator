document.body.onload = addElement;
function addElement() {

    //Set # of columns
    const gridContainer = document.querySelector(".grid-container");
    const GRID_COLUMNS = gridContainer.dataset.gridcolumns;
    gridContainer.style.setProperty('--grid-columns', GRID_COLUMNS);
    //parse json for user's boxes
    //
    //generate grid off that json
    const json = JSON.parse(gridContainer.dataset.imgjson);
    let i;
    for (i = 0; i < GRID_COLUMNS * GRID_COLUMNS; i++) {
        const newDiv = document.createElement("div");
        const id = i + 1;
        //                  newDiv.textContent = id;
        newDiv.dataset.id = id;
        newDiv.dataset.plantid = json[id].plant_id;
        newDiv.setAttribute('id', 'div1');
        newDiv.setAttribute('class', 'grid-item');
        newDiv.setAttribute('ondrop', 'drop(event)');
        newDiv.setAttribute('ondragover', 'allowDrop(event)');
        newDiv.onclick = () => {
            console.log(newDiv.dataset.id + " was clicked on!:");
            console.log(newDiv);
        }

        document.getElementById('grid').appendChild(newDiv);
    }
}

function allowDrop(ev) {
    ev.preventDefault();
}

function drag(ev) {
    ev.dataTransfer.setData("text", ev.target.id);
}

function drop(ev) {
    ev.preventDefault();
    var data = ev.dataTransfer.getData("text");
    clone = document.getElementById(data).cloneNode(true);
    clone.id = "changed";
    ev.target.appendChild(clone);
}

function changeimage(color) {
    switch (color) {
        case "select":
            document.getElementById("change").setAttribute('src', 'https://i.imgur.com/fJORZNV.png');
            break;
        case "red":
            document.getElementById("change").setAttribute('src', '../assets/seeds_bag.jpg');
            break;
        case "blue":
            document.getElementById("change").setAttribute('src', '../assets/seeds_bag.jpg');
            break;
        case "green":
            document.getElementById("change").setAttribute('src', '../assets/seeds_bag.jpg');
            break;
    }
}