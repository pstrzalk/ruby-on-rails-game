import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const csrfMeta = document.querySelector('meta[name="csrf-token"]')

    if (csrfMeta) {
      this.csrfToken = csrfMeta.content;
      this.gameId = this.data.get("id");

      document.onkeydown = this.handleKey.bind(this);
    } else {
      alert("No CSRF Token");
    }
  }

  handleKey(e) {
    const directionsByKeyCodes = {
      '37': 'l',
      '38': 'f',
      '39': 'r',
      '40': 'b'
    };
    const direction = directionsByKeyCodes[e.keyCode];

    if (!direction) {
      return;
    }

    e.preventDefault();
    e.stopPropagation();

    this.move(direction);
  }

  move(direction) {
    const xhr = new XMLHttpRequest();
    const url = `/games/${this.gameId}/move/${direction}`;

    xhr.open("PUT", url, true);
    xhr.setRequestHeader('X-CSRF-Token', this.csrfToken);
    xhr.send();
  }
}
