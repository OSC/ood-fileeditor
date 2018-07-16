// Helper functions for user preferences

$(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip();
});

var KEY_PREFIX = "ood_editor_store_";

// Set localStorage. Adds a key prefix to reduce overlap likelihood.
function setLocalStorage(key, value) {
    var ood_key = KEY_PREFIX + key;
    localStorage.setItem(ood_key, value);
    return null;
}

// Get localStorage. Adds a key prefix added by setter.
function getLocalStorage(key) {
    var ood_key = KEY_PREFIX + key;
    return localStorage.getItem(ood_key);
}

// Set a user preference key to a specific value.
function setUserPreference(key, value) {
    return setLocalStorage(key, value);
}

// Get the current value of the key from preferences.
function getUserPreference(key) {
    return getLocalStorage(key);
}
