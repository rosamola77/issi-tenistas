"use strict";

function include(htmlFile, selector) {
    let xhr = new XMLHttpRequest();
    xhr.open("GET", htmlFile, false); // Becomes synchronous
    xhr.addEventListener("load", function() {
        if (xhr.status === 200) {
            document.querySelector(selector).innerHTML += xhr.responseText;
        } else {
            console.error(htmlFile + " does not exist");
        }
    });
    xhr.send();
}

window.include = include;
