// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import * as ActiveStorage from '@rails/activestorage'
import 'channels'
// import 'bootstrap/dist/js/bootstrap'
import * as bootstrap from 'bootstrap';
import 'bootstrap/dist/css/bootstrap';
require('stylesheets/application.scss')
import '@fortawesome/fontawesome-free/js/all'

import { config, library, dom } from '@fortawesome/fontawesome-svg-core'
config.mutateApproach = 'sync'
import { faGithub } from '@fortawesome/free-brands-svg-icons'
library.add(faGithub)
dom.watch()

Rails.start()
Turbolinks.start()
ActiveStorage.start()

document.addEventListener('turbolinks:load', function () {
  const alerts = document.querySelectorAll('.alert-dismissible');
  alerts.forEach((alert) => {
    setTimeout(() => {
      const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
      bsAlert.close();
    }, 5000);
  });
});
