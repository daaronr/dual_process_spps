(function($) {

    $(document).ready(function() {

        var breakpoints = {
            'mobile': '640',
            'tablet': '768',
        };
        var isMobile = breakpoints.mobile >= $(window).width() ? 1 : 0;
        var isTablet = breakpoints.tablet >= $(window).width() && $(window).width()>breakpoints.mobile ? 1 : 0;

        // SCROLL-TO-TOP

        $("#up-link").click(function() {
            $('html, body').animate({
                scrollTop: $("#header").offset().top
            }, 1000);
        });


        // FOOTER EMAIL SUBSCRIBER FORM

        $('#footer .email-subscribe').validate({
            rules: {
                EMAIL: {
                    required: true,
                    email: true
                }
            },
            showErrors: function(map, list) {},
            invalidHandler: function(e, validator) {
                if (validator.numberOfInvalids()) {
                    var el = $('input[name=EMAIL]');
                    el.addClass('validator-field-error').attr('placeholder', 'Please enter a valid email.').val('');
                    setTimeout(function() {
                        el.removeClass('validator-field-error');
                    }, 1500);
                }
            }
        });

        // DONATE ONLINE FORM

        // Placeholder Text
        var formDonate = $('#webform-client-form-2350');
        formDonate.find('#webform-component-card-information .webform-component').each(function(){
            var placeholder = $(this).find('label').text();
            $(this).find('input').attr('placeholder', placeholder);
        });

        // Calculate totals
        var formDonateDonations = $('#webform-client-form-2350').find('input[type="number"]');
        formDonateDonations.on('change', function(){
            var total = 0;
            formDonateDonations.each(function(){
                total += Math.abs($(this).val()*1);
            });
            formDonate.find('input[name="submitted[totals][total]"]').val(total);
        });


        // HOME PAGE BLOCKQUOTE CAROUSEL
        // https://github.com/richardscarrott/jquery-ui-carousel
        // To set the carousel cycle speed, edit the control right on the page. The setting is right
        // in the carousel div tag:
        // <div class="carousel" data-interval="15000">
        // where data-interval is set in milliseconds (eg: 15000 = 15 sec)
        if($.isFunction($.fn.carousel)) {
            $('.carousel').carousel();
        }
        // ACCORDION
        accordions = $('.accordion');
        accordions.accordion({
            collapsible: true,
            active: true,
            heightStyle: 'content',
            header: 'h3',
            activate: function(e) {
                // Scroll the page so the clicked accordion element is at the top of the page.
                var viewportHt = $(window).height();
                var viewportTop = $(window).scrollTop();
                with($(this)) {
                    if (find('.ui-state-active').length) {
                        var elementTop = find('.ui-state-active').offset().top;
                        if (elementTop - viewportTop > viewportHt / 2 || 1) {
                            $('html, body').animate({
                                scrollTop: elementTop - 20
                            }, 500);
                        }
                    }
                }
            }
        });
        with(accordions) {
            if (length) {
                find('.accordion-container').hide();
                find('.accordion-wrapper').first().find('.accordion-container').show();
                find('.accordion-title').click(function() {
                    if ($(this).hasClass('open')) {
                        $(this).removeClass('open');
                        $(this).parent().find('.accordion-container').slideUp();
                    } else {
                        $(this).addClass('open');
                        $(this).parent().find('.accordion-container').slideDown();
                    }
                    return false;
                });
            }
        }

        // LEGACY FIELDSET ACCORDION (See: gq-legacy.css for styling)
        accordionsFieldset = $('.collapsible');
        accordionsFieldset.accordion({
            collapsible: true,
            active: true,
            heightStyle: 'content',
            header: 'legend',
            activate: function(e) {
                // Scroll the page so the clicked accordion element is at the top of the page.
                var viewportHt = $(window).height();
                var viewportTop = $(window).scrollTop();
                with($(this)) {
                    if (find('.ui-state-active').length) {
                        var elementTop = find('.ui-state-active').offset().top;
                        if (elementTop - viewportTop > viewportHt / 2 || 1) {
                            $('html, body').animate({
                                scrollTop: elementTop - 20
                            }, 500);
                        }
                    }
                }
            }
        });
        with(accordionsFieldset) {
            if (length) {
                find('.accordion-container').hide();
                find('.accordion-wrapper').first().find('.accordion-container').show();
                find('.accordion-title').click(function() {
                    if ($(this).hasClass('open')) {
                        $(this).removeClass('open');
                        $(this).parent().find('.accordion-container').slideUp();
                    } else {
                        $(this).addClass('open');
                        $(this).parent().find('.accordion-container').slideDown();
                    }
                    return false;
                });
            }
        }

        // FOOTNOTES
        // Note: The footnotes module implements it's own accordion, not related to Drupal's native jQuery accordion.
        if ($('.footnotes').length) {

            // Wrap the whole footnotes block in a div so it opens as a single block.
            $('.footnotes').wrap('<div class="footnote-block"></div>');
            $('.footnotes > ul').wrap('<div class="footnote-content"/>');
            $('.footnote-block').prepend('<div style="clear:both"></div><div class="show-hide"><span class="expand">Expand</span><span class="collapse">Collapse</span> Footnotes</div>');

            $('.footnote-block').accordion({
                collapsible: true,
                autoHeight: true,
                active: false,
                header: '.show-hide',
                heightStyle: 'content',
                activate: function(e) {
                    // If the top of the accordion element header is further than halfway down the page,
                    // scroll the page to the top of the element.
                    var viewportHt = $(window).height();
                    var viewportTop = $(window).scrollTop();
                    with($(this)) {
                        if (find('.ui-state-active').length) {
                            var elementTop = find('.ui-state-active').offset().top;
                            if (elementTop - viewportTop > viewportHt / 2) {
                                $('html, body').animate({
                                    scrollTop: elementTop - 20
                                }, 500);
                            }
                        }
                    }
                }
            });

            // If the footnote index is clicked and the footnotes blocka t the bottom of the page is collapsed,
            // open it, wait until it has expanded, then to jump to it.
            $('a.see-footnote').click( function(){
                var hash = $(this).attr('href').split('#')[1];
                with($('.footnote-block .show-hide')){
                    if(!$('.footnote-block .show-hide.ui-state-active').length) {
                        document.location='#top';
                        $('.footnote-block .show-hide').click();
                        window.setTimeout(function(){document.location='#'+hash;},750);
                    }
                }
            });

            // This one works in reverse. If the footnote at the bottom of the page is clicked and the corresponding footnote
            // index is inside a collapsed accordion, this expands the accordion so we can scroll to it.
            $('.footnote-label').on('click',function(i,u){
                var hash = $(this).attr('href').split('#')[1];
                var currAccordion = $('#'+hash).parents('.ui-accordion-content').prev('h3');
                if(!currAccordion.hasClass('ui-state-active')) currAccordion.click();
                window.setTimeout(function(){$('html, body').animate({ scrollTop: $('#'+hash).offset().top - 20 }, 1);},750);
            });
    if (window.location.href.indexOf("#footnote_link") > -1) {
    $('a[href^="#"]').on('ready',function() {
        var target = $(this.getAttribute('href'));
        if( target.length ) {
            event.preventDefault();
            $('html, body').stop().animate({
                scrollTop: target.offset().top
            }, 1000);
        }
    });
}
        }

        // INITIALIZE MENUS AND SEARCH

        /* Initializes Mobile and Desktop menu functions as needed. */
        function toggleMenu() {

            var isMobile = breakpoints.mobile >= $(window).width() ? 1 : 0;

            // Load the responsive menu only once, but reinstate our custom
            // menu click actions any time the page changes size
            // (because MeanMenu doesn't offer a callback to tell us when it has reloaded).
            if (isMobile) {
                if (!this.hasMobileMenu) {
                    initMobileMenu();
                    this.hasMobileMenu = 1;
                }
                setMobileMenuActions();
            } else {
                $('#block-search-form .btn-close').click();
                if (!this.hasSrch) {
                    initDesktopSearch();
                    this.hasSrch = 1;
                }
            }

        }
        window.resizeTimer = setTimeout(toggleMenu, 250);
        $(window).resize(function() {
            clearTimeout(window.resizeTimer ? resizeTimer : 0);
            window.resizeTimer = setTimeout(toggleMenu, 250);
        });

        //if(Modernizr.touch){
        if(isTablet){
            $('#block-system-main-menu ul li').not('#block-system-main-menu ul ul li').each(function(i,u){
                var li = $(this);
                li.data('clicks',0);
                li.find('a').click(function(e){
                    li.data('clicks',li.data('clicks')+1)
                    if(li.data('clicks')==1) {
                        e.preventDefault();
                        return false;
                    }
                });
            });
        }

        // Search form - abort submit if no search term
        $('#header #search-block-form').submit(function(e){
            if(!$(this).find('.form-text').val()){
                e.preventDefault;
                return false;
            }
        });
        $('#search-block-form input[type="text"]').css('background:none')



        // FORMS

        $('#user-login #edit-name').attr('placeholder','Please enter your username.');


        /* Initialize Mean Menu plugin */
        function initMobileMenu() {

            // Note: This selector has to be a container that includes both the menu UL block and
            // the header search block in order for the MeanMenu plugin to toggle them both together.
            $('#header .region-header').meanmenu({
                meanScreenWidth: breakpoints.mobile,
                meanMenuOpen: '<span/>',
                meanMenuClose: '<span/>'
            });
            $('meanmenu-btn-donate').addClass('visible');
            $('#main,#logo').click(function() {
                $('.meanclose').click();
            });

        }

        /* Initialize Mean Menu click actions. */
        function setMobileMenuActions() {

            $('.mean-nav ul li > a').on('click', function() {
                $(this).siblings('a').toggleClass('open');
            });

            $('.meanmenu-reveal').on('click', function() {
                with($('.mean-bar')) {
                    if (!find('.meanmenu-reveal').hasClass('meanclose')) {
                        removeClass('opened');
                    } else {
                        addClass('opened');
                    }
                }
            });

        }


        /* Desktop search box open/close button toggles */
        function initDesktopSearch() {

            var
                mainMenu = $('#header .menu'),
                srchBtnOpen = $('.search-btn-open'),
                /* this is coded directly in page.tpl */
                srchBox = $('#block-search-form'),
                srchForm = srchBox.find('form'),
                srchText = srchBox.find('input:text');

            $('a.header-btn-donate').addClass('visible');

            // open the search box.
            srchBtnOpen.on('click', function(e) {
                e.preventDefault();
                if (!srchForm.hasClass('visible')) {
                    srchForm.addClass('visible');
                    mainMenu.addClass('hidden');
                    srchText.focus();
                } else {
                    srchForm.removeClass('visible');
                    mainMenu.removeClass('hidden');
                }
            });

            // Close the search box.
            srchForm.on('mouseout', function(e) {
                var
                    e = e ? e : window.event;
                tg = (window.event) ? e.srcElement : e.target,
                    reltg = (e.relatedTarget) ? e.relatedTarget : e.toElement;
                if (tg.nodeName != 'DIV') return;
                while (reltg != tg && reltg.nodeName != 'BODY') reltg = reltg.parentNode;
                if (reltg == tg || $(tg).hasClass('form-wrapper')) return;
                e.preventDefault();
                srchForm.removeClass('visible');
                mainMenu.removeClass('hidden');
            });

            // Close the search box.
            srchBox.find('.btn-close').on('click', function(e) {
                e.preventDefault();
                //srchBox.removeClass('visible');
                srchForm.removeClass('visible');
                mainMenu.removeClass('hidden');
            });

            // Set dropdown menu left position for desktop.
            $('#header ul.menu:first-child > li').each(function(index, value) {

                var menu_width = $(this).find('ul').width();
                if (menu_width) {
                    if (index == 0) {
                        $(this).find('.menu').css({
                            'left': '0'
                        });
                    } else if (index == $('#header ul.menu:first-child > li').length - 1) {
                        $(this).find('.menu').css({
                            'right': '0'
                        });
                    } else {
                        var left = -menu_width / 2 + $(this).innerWidth() / 2;
                        $(this).find('.menu').css({
                            'left': left + 'px'
                        });
                    }
                }
            });

        }

        // IMAGE OVERLAY

        // A simple overlay for viewing large images.
        imgTypes = ['jpg', 'jpeg', 'png', 'gif'];
        $('body').append('<div id="op-overlay"><div class="img"/><div class="close"/></div>');
        $overlay = $('#op-overlay');

        $overlay.find('.close').click(function() {
            $overlay.fadeOut(200)
        });
        $overlay.find('.img').click(function() {
            $overlay.fadeOut(200)
        });


        $('a img').each(function(i, e) {
            with($(this).parent('a')) {
                if (length) {
                    for (n = 0; n < imgTypes.length; n++) {
                        if (attr('href').indexOf('.' + imgTypes[n]) > 1) {
                            $(this).parent('a').click(function(e) {
                                $overlay.find('.img').html('<img src="' + $(this).attr('href') + '">');
                                $overlay.fadeIn(400);
                                e.preventDefault();
                                return false;
                            });
                            n = imgTypes.length;
                        }
                    }
                }
            }
        });

        // TABLE OF CONTENTS

        var tocScrollSpeed = 800;

        /* Plug-in jquery.scrollTo.min.js required here is already provided by Table of Contents module unless
           accidental module settings prevent it.
           */
        if (!$.scrollTo) $.getScript('//cdn.jsdelivr.net/jquery.scrollto/2.1.0/jquery.scrollTo.min.js');

        /* Override buggy Table of Contents module jQuery click action and replace with
           our own to remedy Safari and Chrome scroll bugs.
           */
        $('.toc-level-1, .toc-level-2, .toc-level-3, .toc-level-4, .toc-level-5').unbind('click')
            .on('click', function(e) {
                e.preventDefault();
                var anchorId = $('a', this).attr('href').toString();
                anchorId = anchorId.indexOf('#') == 0 ? anchorId : '';
                $('html,body').scrollTo(anchorId, tocScrollSpeed);
                return false;
            });

        $('.back-to-top, .toc-back-to-top a').unbind('click')
            .on('click', function(e) {
                e.preventDefault();
                $('html,body').scrollTo('#toc', tocScrollSpeed);
                return false;
            });
        $('.back-to-top').unbind('click')
            .on('click', function(e) {
                e.preventDefault();
                $('html,body').scrollTo('#skip', tocScrollSpeed);
                return false;
            });

        // MULTI-SELECT DROP-DOWN MENUS
        // Converstions page multi-select
        var convForm = $('.view-conversations form');
        var convSelect = convForm.find('.form-select');
        convForm.data('changed',0);
        convSelect.multiselect({
            selectedList: 1,
            checkAllText: 'All Conversations',
            noneSelectedText: 'All Conversations',
            height: 'auto',
            minWidth: 'auto'
        });
        convSelect.change(function(){
            convForm.data('changed',1);
        });
        convForm.find('button').on('mouseup',function(){
            if($(this).hasClass('ui-state-active') && convForm.data('changed')) convForm.submit();
        });
        convForm.focusout(function(){
            if(convForm.data('changed')) convForm.submit();
        });

        var multiSelect = $('.ui-multiselect-menu');
        if(multiSelect.length) {
            $(window).resize(function(){ multiSelect.hide(); });
        }

        // TABLE OVERFLOW SLIDER (SCROLLBOX)
        scrollBoxLabel = (isMobile?'Drag':'Click and drag') +' to scroll the table.';
        pageWd = $('#content').width();
        aside = $('#sidebar-second');

        // Set footnotes display to block and make them invisible so we can get measurements from them.
        $('.footnotes').css('visibility','hidden').css('display','block');
        table = $('#content-area table').each(function(i,u){
            with($(this)){
                var scrollWd = width();
                var parentWd = parent().width();
                if(width() > parentWd) {
                    // expand table container to full available width if the sidebar is not in the way.
                    parentWd = pageWd<scrollWd? pageWd:scrollWd;
                    // adjust for the footnotes left margin as needed.
                    parentWd = parents('.footnotes').length? parentWd-40:parentWd;
                    wrap('<div class="scroll-box scroll-box-'+i+'"/>');
                    scrollBox = $('.scroll-box-'+i);
                    // DEV NOTE: undefined aside.offset was causing an error so we test for it, not sure if not setting the css width creates another issue.
                    if (aside.offset()) {
                        if(scrollBox.offset().top > (aside.offset().top+aside.height())){
                            scrollBox.css({ width:parentWd });
                        }
                    }
                }
            }
        });
        // Set footnotes display to none and set to visible again.
        $('.footnotes').css('display','none').css('visibility','visible');

    });

})(jQuery); // .noConflict()
