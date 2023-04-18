import { Controller } from "@hotwired/stimulus";
import { Application } from "@hotwired/stimulus";
import Carousel from "stimulus-carousel";

const application = Application.start();
application.register("carousel", Carousel);

// Connects to data-controller="carousel"
export default class extends Controller {
  connect() {
    super.connect();
    // console.log('Do what you want here.');

    // The swiper instance.
    this.swiper;

    // Default options for every carousels.
    this.defaultOptions;
  }
}