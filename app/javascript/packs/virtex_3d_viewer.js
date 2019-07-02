import { Viewport } from 'virtex3d';
import { CssInjection } from '../../assets/javascripts/modules/css_injection.js';
import { CommonViewerBehavior } from '../../assets/javascripts/modules/common_viewer_behavior.js';

CssInjection.appendToHead();
CommonViewerBehavior.initializeViewer(function() {
  var viewer = $('#virtex-3d-viewer');
  var viewport = new Viewport({
    target: viewer[0],
    data: {
        file: viewer.data('three-dimensional-file'),
        fullscreenEnabled: true,
        showStats: false,
    }
  });

  viewer.prev('.buttons').find('.zoom-in').on('click', function(e) {
    e.preventDefault();
    viewport.zoomIn();
  });

  viewer.prev('.buttons').find('.zoom-out').on('click', function(e) {
      e.preventDefault();
      viewport.zoomOut();
  });
});
