var whiteSVG_Icon = safari.extension.baseURI + 'PiP_Toolbar_Icon_white.svg';
var blackSVG_Icon = safari.extension.baseURI + 'PiP_Toolbar_Icon.svg';

safari.self.addEventListener("message", messageHandler);

window.onfocus = function() {
  previousResult = null;
  checkForVideo();
};

new MutationObserver(checkForVideo).observe(document, {subtree: true, childList: true});

function dispatchMessage(messageName, parameters) {
  safari.extension.dispatchMessage(messageName, parameters);
}

function messageHandler(event) {
  if (event.name === "enablePiP" && getVideo() != null) {
    enablePiP();
  } else if (event.name === "addCustomPiPButtonToPlayer") {
    window[event.message.callback]()
  }
}

var previousResult = null;

function checkForVideo() {
  if (getVideo() != null) {
    addCustomPiPButtons();
    if (previousResult === null || previousResult === false) {
      dispatchMessage("videoCheck", {found: true});
    }
    previousResult = true;
  } else if (window == window.top) {
    if (previousResult === null || previousResult === true) {
      dispatchMessage("videoCheck", {found: false});
    }
    previousResult = false;
  }
}

function getVideo() {
  return document.getElementsByTagName('video')[0];
}

function enablePiP() {
  getVideo().webkitSetPresentationMode('picture-in-picture');
}

var players = [
  {name: "YouTube", shouldAddButton: shouldAddYouTubeButton, addButton: addYouTubeButton},
  {name: "VideoJS", shouldAddButton: shouldAddVideoJSButton, addButton: addVideoJSButton},
  {name: "Netflix", shouldAddButton: shouldAddNetflixButton, addButton: addNetflixButton},
  {name: "Wistia", shouldAddButton: shouldAddWistiaButton, addButton: addWistiaButton}
];

function addCustomPiPButtons() {
  for (const player of players) {
    if (player.shouldAddButton()) {
      dispatchMessage("pipCheck", {callback: player.addButton.name}) //Sets the callback to the player's addButton
    }
  }
}

function shouldAddYouTubeButton() {
  return (location.hostname.match(/^(www\.)?youtube\.com$/) || document.getElementsByClassName("ytp-right-controls").length > 0) &&
         document.getElementsByClassName('PiPifierButton').length == 0;
}

function addYouTubeButton() {
  if (!shouldAddYouTubeButton()) return;
  var button = document.createElement("button");
  button.className = "ytp-button PiPifierButton";
  button.title = "PiP (by PiPifier)";
  button.onclick = enablePiP;
  var buttonImage = document.createElement("img");
  buttonImage.src = whiteSVG_Icon;
  buttonImage.width = 22;
  buttonImage.height = 36;
  button.appendChild(buttonImage);

  document.getElementsByClassName("ytp-right-controls")[0].appendChild(button);
}

function shouldAddVideoJSButton() {
  return document.getElementsByClassName('vjs-control-bar').length > 0 &&
         document.getElementsByClassName('PiPifierButton').length == 0;
}

function addVideoJSButton() {
  if (!shouldAddVideoJSButton()) return;
  var button = document.createElement("button");
  button.className = "PiPifierButton vjs-control vjs-button";
  button.title = "PiP (by PiPifier)";
  button.onclick = enablePiP;
  var buttonImage = document.createElement("img");
  buttonImage.src = whiteSVG_Icon;
  buttonImage.width = 16;
  buttonImage.height = 30;
  button.appendChild(buttonImage);
  var fullscreenButton = document.getElementsByClassName("vjs-fullscreen-control")[0];
  fullscreenButton.parentNode.insertBefore(button, fullscreenButton);
}

function shouldAddWistiaButton() {
  return document.getElementsByClassName('wistia_playbar').length > 0 &&
         document.getElementsByClassName('PiPifierButton').length == 0;
}

function addWistiaButton() {
  if (!shouldAddWistiaButton()) return;
  var button = document.createElement("button");
  button.className = "PiPifierButton w-control w-control--fullscreen w-is-visible";
  button.alt = "Picture in Picture";
  button.title = "PiP (by PiPifier)";
  button.onclick = enablePiP;
  var buttonImage = document.createElement("img");
  buttonImage.src = whiteSVG_Icon;
  buttonImage.width = 28;
  buttonImage.height = 18;
  buttonImage.style.verticalAlign = "middle";
  button.appendChild(buttonImage);
  document.getElementsByClassName("w-control-bar__region--airplay")[0].appendChild(button);
}

function shouldAddNetflixButton() {
  return location.hostname.match('netflix') &&
         document.getElementsByClassName('PiPifierButton').length == 0;
}

function addNetflixButton(timeOutCounter) {
  if (!shouldAddNetflixButton()) return;
  if (timeOutCounter == null) timeOutCounter = 0;
  var button = document.createElement("button");
  button.className = "PiPifierButton";
  button.title = "PiP (by PiPifier)";
  button.onclick = enablePiP;
  button.style.backgroundColor = "transparent";
  button.style.border = "none";
  button.style.maxHeight = "inherit";
  button.style.width = "70px";
  button.style.marginRight = "2px";
  var buttonImage = document.createElement("img");
  buttonImage.src = whiteSVG_Icon;
  buttonImage.style.verticalAlign = "middle";
  buttonImage.style.maxHeight = "40%";
  button.appendChild(buttonImage);
  var playerStatusDiv = document.getElementsByClassName("player-status")[0];
  if (playerStatusDiv == null && timeOutCounter < 3) {
    setTimeout(function() {
      addNetflixButton(timeOutCounter + 1);
    }, 3000);
    return;
  }
  playerStatusDiv.insertBefore(button, playerStatusDiv.firstChild);
}
