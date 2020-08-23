window.addEventListener('DOMContentLoaded',function() {
  new Swiper('.swiper-container', {
      pagination: {
          el: '.swiper-pagination',
      },
  })
});

// 見本の$(function)から始まる形とは違う記述ではありますが、jQueryがうまく読み込めず
// コンソールで"is not defined"というエラーが出てしまっていた。原因は不明・・・
// そのため全てのDOMが構成されてからイベントを発火させる記述としました。
