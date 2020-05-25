/*!

 =========================================================
 * Material Dashboard Dark Edition - v2.1.0
 =========================================================

 * Product Page: https://www.creative-tim.com/product/material-dashboard-dark
 * Copyright 2019 Creative Tim (http://www.creative-tim.com)

 * Coded by www.creative-tim.com

 =========================================================

 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 */

(function() {
  isWindows = navigator.platform.indexOf('Win') > -1 ? true : false;

  if (isWindows) {
    // if we are on windows OS we activate the perfectScrollbar function
    $('.sidebar .sidebar-wrapper, .main-panel').perfectScrollbar();

    $('html').addClass('perfect-scrollbar-on');
  } else {
    $('html').addClass('perfect-scrollbar-off');
  }
})();


var breakCards = true;

var searchVisible = 0;
var transparent = true;

var transparentDemo = true;
var fixedTop = false;

var mobile_menu_visible = 0,
  mobile_menu_initialized = false,
  toggle_initialized = false,
  bootstrap_nav_initialized = false;

var seq = 0,
  delays = 80,
  durations = 500;
var seq2 = 0,
  delays2 = 80,
  durations2 = 500;

$(document).ready(function() {

  $('body').bootstrapMaterialDesign();

  $sidebar = $('.sidebar');

  md.initSidebarsCheck();

  window_width = $(window).width();

  // check if there is an image set for the sidebar's background
  md.checkSidebarImage();

  //    Activate bootstrap-select
  if ($(".selectpicker").length != 0) {
    $(".selectpicker").selectpicker();
  }

  //  Activate the tooltips
  $('[rel="tooltip"]').tooltip();

  $('.form-control').on("focus", function() {
    $(this).parent('.input-group').addClass("input-group-focus");
  }).on("blur", function() {
    $(this).parent(".input-group").removeClass("input-group-focus");
  });

  // remove class has-error for checkbox validation
  $('input[type="checkbox"][required="true"], input[type="radio"][required="true"]').on('click', function() {
    if ($(this).hasClass('error')) {
      $(this).closest('div').removeClass('has-error');
    }
  });

});

$(document).on('click', '.navbar-toggler', function() {
  $toggle = $(this);

  if (mobile_menu_visible == 1) {
    $('html').removeClass('nav-open');

    $('.close-layer').remove();
    setTimeout(function() {
      $toggle.removeClass('toggled');
    }, 400);

    mobile_menu_visible = 0;
  } else {
    setTimeout(function() {
      $toggle.addClass('toggled');
    }, 430);

    var $layer = $('<div class="close-layer"></div>');

    if ($('body').find('.main-panel').length != 0) {
      $layer.appendTo(".main-panel");

    } else if (($('body').hasClass('off-canvas-sidebar'))) {
      $layer.appendTo(".wrapper-full-page");
    }

    setTimeout(function() {
      $layer.addClass('visible');
    }, 100);

    $layer.click(function() {
      $('html').removeClass('nav-open');
      mobile_menu_visible = 0;

      $layer.removeClass('visible');

      setTimeout(function() {
        $layer.remove();
        $toggle.removeClass('toggled');

      }, 400);
    });

    $('html').addClass('nav-open');
    mobile_menu_visible = 1;

  }

});

// activate collapse right menu when the windows is resized
$(window).resize(function() {
  md.initSidebarsCheck();

  // reset the seq for charts drawing animations
  seq = seq2 = 0;

  setTimeout(function() {
    md.initDashboardPageCharts();
  }, 500);
});



md = {
  misc: {
    navbar_menu_visible: 0,
    active_collapse: true,
    disabled_collapse_init: 0
  },

  checkSidebarImage: function() {
    $sidebar = $('.sidebar');
    image_src = $sidebar.data('image');

    if (image_src !== undefined) {
      sidebar_container = '<div class="sidebar-background" style="background-image: url(' + image_src + ') "/>';
      $sidebar.append(sidebar_container);
    }
  },

  initSidebarsCheck: function() {
    if ($(window).width() <= 991) {
      if ($sidebar.length != 0) {
        md.initRightMenu();
      }
    }
  },

  initDashboardPageCharts: function() {

    if ($('#dailySalesChart').length != 0 || $('#completedTasksChart').length != 0 || $('#websiteViewsChart').length != 0) {


      $.get(
          '/GetInternPerformanceData').then(function (res) {
            console.log("res: ", res);
              if (res) {
                    /* ----------==========     Daily Sales Chart initialization    ==========---------- */

                  dataDailySalesChart = {
                     labels: res.labels,
                     series: res.series
                  };

                  optionsDailySalesChart = {
                    lineSmooth: Chartist.Interpolation.cardinal({
                      tension: 0,
                    }),
                    low: 0,
                    high: 30, // creative tim: we recommend you to set the high sa the biggest value + something for a better look
                    chartPadding: {
                      top: 0,
                      right: 0,
                      bottom: 0,
                      left: 0
                    },
                    plugins: [
                      Chartist.plugins.legend({
                        legendNames: res.legendNames,
                    })
                    ],
                      width: '100%',
                      height: '500px'
                  };

                  // var dailySalesChart = new Chartist.Line('#dailySalesChart', dataDailySalesChart, optionsDailySalesChart);
                  new Chartist.Line('#dailySalesChart', dataDailySalesChart, optionsDailySalesChart);

                  // md.startAnimationForLineChart(dailySalesChart);


              }
          }
      );


      /* ----------==========     Completed Tasks Chart initialization    ==========---------- */

      dataCompletedTasksChart = {
        labels: ['12p', '3p', '6p', '9p', '12p', '3a', '6a', '9a'],
        series: [
          [230, 750, 450, 300, 280, 240, 200, 190]
        ]
      };

      optionsCompletedTasksChart = {
        lineSmooth: Chartist.Interpolation.cardinal({
          tension: 0
        }),
        low: 0,
        high: 1000, // creative tim: we recommend you to set the high sa the biggest value + something for a better look
        chartPadding: {
          top: 0,
          right: 0,
          bottom: 0,
          left: 0
        }
      };

      var completedTasksChart = new Chartist.Line('#completedTasksChart', dataCompletedTasksChart, optionsCompletedTasksChart);

      // start animation for the Completed Tasks Chart - Line Chart
      md.startAnimationForLineChart(completedTasksChart);


      /* ----------==========     Emails Subscription Chart initialization    ==========---------- */


      $.get(
          '/GetMedicineAllergyByMostPatients_forchart').then(function (res) {
            console.log("res: ", res);
              if (res) {

                  var dataWebsiteViewsChart = {
                    labels: res.labels,
                    series: [
                      res.series

                    ]
                  };
                  var optionsWebsiteViewsChart = {
                    axisX: {
                      showGrid: true
                    },
                    low: 0,
                    high: res.series[0]*1.2,
                    chartPadding: {
                      top: 0,
                      right: 5,
                      bottom: 0,
                      left: 0
                    },
                      width: '100%',
                      height: '500px'
                  };
                  var responsiveOptions = [
                    ['screen and (max-width: 640px)', {
                      seriesBarDistance: 5,
                      axisX: {
                        labelInterpolationFnc: function(value) {
                          return value[0];
                        }
                      }
                    }]
                  ];
                  new Chartist.Bar('#websiteViewsChart', dataWebsiteViewsChart, optionsWebsiteViewsChart, responsiveOptions);



              }
          }
      );

    }
  },

  showNotification: function(from, align) {
    type = ['', 'info', 'danger', 'success', 'warning', 'primary'];

    color = Math.floor((Math.random() * 5) + 1);

    $.notify({
      icon: "add_alert",
      message: "Welcome to <b>Material Dashboard</b> - a beautiful freebie for every web developer."

    }, {
      type: type[color],
      timer: 3000,
      placement: {
        from: from,
        align: align
      }
    });
  },

  checkScrollForTransparentNavbar: debounce(function() {
    if ($(document).scrollTop() > 260) {
      if (transparent) {
        transparent = false;
        $('.navbar-color-on-scroll').removeClass('navbar-transparent');
      }
    } else {
      if (!transparent) {
        transparent = true;
        $('.navbar-color-on-scroll').addClass('navbar-transparent');
      }
    }
  }, 17),

  initRightMenu: debounce(function() {

    $sidebar_wrapper = $('.sidebar-wrapper');

    if (!mobile_menu_initialized) {
      console.log('intra');
      $navbar = $('nav').find('.navbar-collapse').children('.navbar-nav');

      mobile_menu_content = '';

      nav_content = $navbar.html();

      nav_content = '<ul class="nav navbar-nav nav-mobile-menu">' + nav_content + '</ul>';

      navbar_form = $('nav').find('.navbar-form').length != 0 ? $('nav').find('.navbar-form')[0].outerHTML : null;

      $sidebar_nav = $sidebar_wrapper.find(' > .nav');

      // insert the navbar form before the sidebar list
      $nav_content = $(nav_content);
      $navbar_form = $(navbar_form);
      $nav_content.insertBefore($sidebar_nav);
      $navbar_form.insertBefore($nav_content);

      $(".sidebar-wrapper .dropdown .dropdown-menu > li > a").click(function(event) {
        event.stopPropagation();

      });

      // simulate resize so all the charts/maps will be redrawn
      window.dispatchEvent(new Event('resize'));

      mobile_menu_initialized = true;
    } else {
      if ($(window).width() > 991) {
        // reset all the additions that we made for the sidebar wrapper only if the screen is bigger than 991px
        $sidebar_wrapper.find('.navbar-form').remove();
        $sidebar_wrapper.find('.nav-mobile-menu').remove();

        mobile_menu_initialized = false;
      }
    }
  }, 200),

  startAnimationForLineChart: function(chart) {
    chart.on('draw', function(data) {
      if ((data.type === 'line' || data.type === 'area') && window.matchMedia("(min-width: 900px)").matches) {
        data.element.animate({
          d: {
            begin: 600,
            dur: 700,
            from: data.path.clone().scale(1, 0).translate(0, data.chartRect.height()).stringify(),
            to: data.path.clone().stringify(),
            easing: Chartist.Svg.Easing.easeOutQuint
          }
        });
      } else if (data.type === 'point') {
        seq++;
        data.element.animate({
          opacity: {
            begin: seq * delays,
            dur: durations,
            from: 0,
            to: 1,
            easing: 'ease'
          }
        });
      }

    });

    seq = 0;

  },
  startAnimationForBarChart: function(chart) {
    chart.on('draw', function(data) {
      if (data.type === 'bar' && window.matchMedia("(min-width: 900px)").matches) {
        seq2++;
        data.element.animate({
          opacity: {
            begin: seq2 * delays2,
            dur: durations2,
            from: 0,
            to: 1,
            easing: 'ease'
          }
        });
      }

    });

    seq2 = 0;

  }
};

// Returns a function, that, as long as it continues to be invoked, will not
// be triggered. The function will be called after it stops being called for
// N milliseconds. If `immediate` is passed, trigger the function on the
// leading edge, instead of the trailing.

function debounce(func, wait, immediate) {
  var timeout;
  return function() {
    var context = this,
      args = arguments;
    clearTimeout(timeout);
    timeout = setTimeout(function() {
      timeout = null;
      if (!immediate) func.apply(context, args);
    }, wait);
    if (immediate && !timeout) func.apply(context, args);
  };
};

(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['chartist'], function (chartist) {
            return (root.returnExportsGlobal = factory(chartist));
        });
    } else if (typeof exports === 'object') {
        // Node. Does not work with strict CommonJS, but
        // only CommonJS-like enviroments that support module.exports,
        // like Node.
        module.exports = factory(require('chartist'));
    } else {
        root['Chartist.plugins.legend'] = factory(root.Chartist);
    }
}(this, function (Chartist) {
    /**
     * This Chartist plugin creates a legend to show next to the chart.
     *
     */
    'use strict';

    var defaultOptions = {
        className: '',
        classNames: false,
        removeAll: false,
        legendNames: false,
        clickable: true,
        onClick: null,
        position: 'top'
    };

    Chartist.plugins = Chartist.plugins || {};

    Chartist.plugins.legend = function (options) {

        // Catch invalid options
        if (options && options.position) {
            if (!(options.position === 'top' || options.position === 'bottom' || options.position instanceof HTMLElement)) {
                throw Error('The position you entered is not a valid position');
            }
            if (options.position instanceof HTMLElement) {
                // Detatch DOM element from options object, because Chartist.extend
                // currently chokes on circular references present in HTMLElements
                var cachedDOMPosition = options.position;
                delete options.position;
            }
        }

        options = Chartist.extend({}, defaultOptions, options);

        if (cachedDOMPosition) {
            // Reattatch the DOM Element position if it was removed before
            options.position = cachedDOMPosition
        }

        return function legend(chart) {

            function removeLegendElement() {
                var legendElement = chart.container.querySelector('.ct-legend');
                if (legendElement) {
                    legendElement.parentNode.removeChild(legendElement);
                }
            }

            // Set a unique className for each series so that when a series is removed,
            // the other series still have the same color.
            function setSeriesClassNames() {
                chart.data.series = chart.data.series.map(function (series, seriesIndex) {
                    if (typeof series !== 'object') {
                        series = {
                            value: series
                        };
                    }
                    series.className = series.className || chart.options.classNames.series + '-' + Chartist.alphaNumerate(seriesIndex);
                    return series;
                });
            }

            function createLegendElement() {
                var legendElement = document.createElement('ul');
                legendElement.className = 'ct-legend';
                if (chart instanceof Chartist.Pie) {
                    legendElement.classList.add('ct-legend-inside');
                }
                if (typeof options.className === 'string' && options.className.length > 0) {
                    legendElement.classList.add(options.className);
                }
                if (chart.options.width) {
                    legendElement.style.cssText = 'width: ' + chart.options.width + 'px;margin: 0 auto;';
                }
                return legendElement;
            }

            // Get the right array to use for generating the legend.
            function getLegendNames(useLabels) {
                return options.legendNames || (useLabels ? chart.data.labels : chart.data.series);
            }

            // Initialize the array that associates series with legends.
            // -1 indicates that there is no legend associated with it.
            function initSeriesMetadata(useLabels) {
                var seriesMetadata = new Array(chart.data.series.length);
                for (var i = 0; i < chart.data.series.length; i++) {
                    seriesMetadata[i] = {
                        data: chart.data.series[i],
                        label: useLabels ? chart.data.labels[i] : null,
                        legend: -1
                    };
                }
                return seriesMetadata;
            }

            function createNameElement(i, legendText, classNamesViable) {
                var li = document.createElement('li');
                li.classList.add('ct-series-' + i);
                // Append specific class to a legend element, if viable classes are given
                if (classNamesViable) {
                    li.classList.add(options.classNames[i]);
                }
                li.setAttribute('data-legend', i);
                li.textContent = legendText;
                return li;
            }

            // Append the legend element to the DOM
            function appendLegendToDOM(legendElement) {
                if (!(options.position instanceof HTMLElement)) {
                    switch (options.position) {
                        case 'top':
                            chart.container.insertBefore(legendElement, chart.container.childNodes[0]);
                            break;

                        case 'bottom':
                            chart.container.insertBefore(legendElement, null);
                            break;
                    }
                } else {
                    // Appends the legend element as the last child of a given HTMLElement
                    options.position.insertBefore(legendElement, null);
                }
            }

            function addClickHandler(legendElement, legends, seriesMetadata, useLabels) {
                legendElement.addEventListener('click', function(e) {
                    var li = e.target;
                    if (li.parentNode !== legendElement || !li.hasAttribute('data-legend'))
                        return;
                    e.preventDefault();

                    var legendIndex = parseInt(li.getAttribute('data-legend'));
                    var legend = legends[legendIndex];

                    if (!legend.active) {
                        legend.active = true;
                        li.classList.remove('inactive');
                    } else {
                        legend.active = false;
                        li.classList.add('inactive');

                        var activeCount = legends.filter(function(legend) { return legend.active; }).length;
                        if (!options.removeAll && activeCount == 0) {
                            // If we can't disable all series at the same time, let's
                            // reenable all of them:
                            for (var i = 0; i < legends.length; i++) {
                                legends[i].active = true;
                                legendElement.childNodes[i].classList.remove('inactive');
                            }
                        }
                    }

                    var newSeries = [];
                    var newLabels = [];

                    for (var i = 0; i < seriesMetadata.length; i++) {
                        if (seriesMetadata[i].legend != -1 && legends[seriesMetadata[i].legend].active) {
                            newSeries.push(seriesMetadata[i].data);
                            newLabels.push(seriesMetadata[i].label);
                        }
                    }

                    chart.data.series = newSeries;
                    if (useLabels) {
                        chart.data.labels = newLabels;
                    }

                    chart.update();

                    if (options.onClick) {
                        options.onClick(chart, e);
                    }
                });
            }

            removeLegendElement();

            var legendElement = createLegendElement();
            var useLabels = chart instanceof Chartist.Pie && chart.data.labels && chart.data.labels.length;
            var legendNames = getLegendNames(useLabels);
            var seriesMetadata = initSeriesMetadata(useLabels);
            var legends = [];

            // Check if given class names are viable to append to legends
            var classNamesViable = Array.isArray(options.classNames) && options.classNames.length === legendNames.length;

            // Loop through all legends to set each name in a list item.
            legendNames.forEach(function (legend, i) {
                var legendText = legend.name || legend;
                var legendSeries = legend.series || [i];

                var li = createNameElement(i, legendText, classNamesViable);
                legendElement.appendChild(li);

                legendSeries.forEach(function(seriesIndex) {
                    seriesMetadata[seriesIndex].legend = i;
                });

                legends.push({
                    text: legendText,
                    series: legendSeries,
                    active: true
                });
            });

            chart.on('created', function (data) {
                appendLegendToDOM(legendElement);
            });

            if (options.clickable) {
                setSeriesClassNames();
                addClickHandler(legendElement, legends, seriesMetadata, useLabels);
            }
        };
    };

    return Chartist.plugins.legend;

}));