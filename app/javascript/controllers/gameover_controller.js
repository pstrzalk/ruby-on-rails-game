import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const winnerIndicatorElement = document.getElementById('winner_indicator');

    if (winnerIndicatorElement) {
      const winnerIdentity = winnerIndicatorElement.dataset.winnerIdentity;

      if (!winnerIdentity) {
        return;
      }

      const playerIdentityElement = document.querySelector('[data-player-identity]');
      if (!playerIdentityElement) {
        winnerIndicatorElement.innerHTML = 'Some brave Prince has rescued the Princess!';

        return;
      }

      const playerIdentity = playerIdentityElement.dataset.playerIdentity;
      if (!playerIdentity) {
        return;
      }

      if (playerIdentity == winnerIdentity) {
        winnerIndicatorElement.innerHTML = 'You have rescued the Princess!';
      } else {
        winnerIndicatorElement.innerHTML = 'You have failed, but some other Prince has rescued the Princess.';

        let failedImages = document.getElementsByClassName('js-failed-mission');
        Array.prototype.forEach.call(failedImages, function(element) {
          element.classList.remove('hidden');
        });

        let successfulImages = document.getElementsByClassName('js-successful-mission');
        Array.prototype.forEach.call(successfulImages, function(element) {
          element.classList.add('hidden');
        });

        const winnerDescriptionElement = document.getElementById('winner_description');
        winnerDescriptionElement.innerHTML = 'You will be eating flies for the rest of your days...';
      }
    }
  }
}
