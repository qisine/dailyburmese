var DailyB = {};
(function($) {
  DailyB.toggleEnglish = function() {
    $(".my").on("click", function() {
      $(this)
        .next(".hide-this")
        .toggle();
    });
  }

  DailyB.init = function() {
    DailyB.toggleEnglish();
  }

  $(DailyB.init);
})(jQuery);
