// $('turbolinks:load', function () {
//   var $player = $('.youtube-player')
//   if ($player.length === 0) {
//     return
//   }

//   if (typeof YT === 'undefined') {
//     var script = document.createElement('script')
//     script.setAttribute('src', "http://www.youtube.com/player_api")
//     document.body.appendChild(script)
//   }

//   var player;
//   // window.onYouTubePlayerAPIReady = function () {
//     var player = new YT.Player('youtube-player', {
//       height: '390',
//       width: '640',
//       videoId: $player.data('video-id'),
//       events: {
//         onReady: onPlayerReady,
//         onStateChange: onPlayerStateChange
//       }
//     });
//   // }

//   // autoplay video
//   function onPlayerReady(event) {
//     event.target.playVideo();
//   }

//   // when video ends
//   function onPlayerStateChange(event) {
//     if(event.data === 0) {
//       alert('done');
//     }
//   }
// })
