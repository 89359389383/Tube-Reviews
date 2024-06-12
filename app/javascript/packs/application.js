// Rails UJSのインポートと起動
import Rails from "@rails/ujs";
Rails.start();

document.addEventListener('DOMContentLoaded', function() {
  console.log('Rails UJS is loaded:', !!Rails);
  document.querySelectorAll('a[data-method]').forEach(function(link) {
    link.addEventListener('click', function(event) {
      console.log('UJS link clicked:', event.target);
    });
  });
});

// jQueryをインポート
import $ from 'jquery';

// Bootstrapをインポート
import "bootstrap"; 

// favorites.jsをインポート
import './favorites';

// Custom SCSSのインポート
import '../stylesheets/custom.scss';

// Social Share Buttonのインポート
import "social-share-button";

import './folder_management';

// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// Uncomment to copy all static images under ./images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('./images', true)
// const imagePath = (name) => images(name, true)

