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
            var i = newDiv.getElementsByTagName('img')[0];
            i.parentNode.removeChild(i);
            //harvest -> increase crop count by one
        }

        document.getElementById('grid').appendChild(newDiv);
    }

    var selectMenu = document.getElementById("seedSelect");
    const plantJson = JSON.parse(selectMenu.dataset.imgjson);
    Object.keys(plantJson).forEach(function (key) {
        var opt = document.createElement("option");
        opt.text = key;
        selectMenu.options.add(opt);
    });

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
    clone.removeAttribute('draggable');
    clone.removeAttribute('ondragstart');
    ev.target.appendChild(clone);
    // decrease seed count by one
}

function changeimage(color) {
    var selectMenu = document.getElementById("seedSelect");
    const plantJson = JSON.parse(selectMenu.dataset.imgjson);
    Object.keys(plantJson).forEach(function (key) {
        if (color === key) {
            document.getElementById("change").setAttribute('src', plantJson[key].image_url);
            document.getElementById("change").setAttribute('draggable', 'true');
        }
    });
    if (color === "select") {
        document.getElementById("change").setAttribute('src', '../assets/seeds_bag.jpg');
        document.getElementById("change").setAttribute('draggable', 'false');
    }
}