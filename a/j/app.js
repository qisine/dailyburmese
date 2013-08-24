var DailyB = {};
(function($) {
  DailyB.toggleEnglish = function() {
    $(".hide-trigger > a:first-child").on("click", function(evt) {
      var t = $(this), sign = "+"; 
      evt.preventDefault();

      t.parent()
        .next(".hide-this")
        .toggle();
      if ($.trim(t.text()) === "+") sign = "-";
      t.text(sign);
    });
  }

  DailyB.init = function() {
    DailyB.toggleEnglish();
  }

  $(DailyB.init);
})(jQuery);
