// Scroll-triggered left border animation for about cards and project cards
(function() {
  'use strict';
  
  if (!('IntersectionObserver' in window)) {
    // Fallback: show borders immediately
    document.querySelectorAll('.about-intro-card, .about-section-card, .experience-card, .about-contents .callout-note').forEach(function(card) {
      card.classList.add('border-animated');
    });
    return;
  }
  
  const borderObserver = new IntersectionObserver(function(entries) {
    entries.forEach(function(entry) {
      if (entry.isIntersecting) {
        entry.target.classList.add('border-animated');
        borderObserver.unobserve(entry.target);
      }
    });
  }, {
    threshold: 0.4,
    rootMargin: '0px 0px -100px 0px'
  });
  
  // Observe all about, experience, and project cards
  document.querySelectorAll('.about-intro-card, .about-section-card, .experience-card, .about-contents .callout-note').forEach(function(card) {
    borderObserver.observe(card);
  });
})();

// Scroll-triggered progress bar animation
(function() {
  'use strict';
  
  // Check if Intersection Observer is supported
  if (!('IntersectionObserver' in window)) {
    // Fallback: animate immediately
    document.querySelectorAll('.progress-bar').forEach(function(bar) {
      const progress = bar.getAttribute('data-progress');
      if (progress) {
        setTimeout(function() {
          bar.style.width = progress + '%';
        }, 100);
      }
    });
    return;
  }
  
  // Create observer for progress bars
  const progressObserver = new IntersectionObserver(function(entries) {
    entries.forEach(function(entry) {
      if (entry.isIntersecting) {
        const bar = entry.target;
        const progress = bar.getAttribute('data-progress');
        
        if (progress && !bar.classList.contains('animated')) {
          bar.classList.add('animated');
          // Small delay for smoother animation
          setTimeout(function() {
            bar.style.width = progress + '%';
          }, 100);
        }
        
        // Unobserve after animation starts
        progressObserver.unobserve(bar);
      }
    });
  }, {
    threshold: 0.3, // Trigger when 30% of element is visible
    rootMargin: '0px 0px -50px 0px' // Trigger slightly before element enters viewport
  });
  
  // Observe all progress bars
  document.querySelectorAll('.progress-bar').forEach(function(bar) {
    progressObserver.observe(bar);
  });
  
  // Also observe KPI cards for fade-in effect
  const kpiObserver = new IntersectionObserver(function(entries) {
    entries.forEach(function(entry) {
      if (entry.isIntersecting) {
        entry.target.style.opacity = '1';
        entry.target.style.transform = 'translateY(0)';
        kpiObserver.unobserve(entry.target);
      }
    });
  }, {
    threshold: 0.2,
    rootMargin: '0px 0px -30px 0px'
  });
  
  // Set initial state for KPI cards
  document.querySelectorAll('.kpi-card').forEach(function(card, index) {
    card.style.opacity = '0';
    card.style.transform = 'translateY(20px)';
    card.style.transition = 'opacity 0.5s cubic-bezier(0.25, 0.46, 0.45, 0.94) ' + (index * 0.1) + 's, transform 0.5s cubic-bezier(0.25, 0.46, 0.45, 0.94) ' + (index * 0.1) + 's';
    kpiObserver.observe(card);
  });
})();

// Flip card functionality for experience cards
document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('.flip-card').forEach(function(card) {
    card.addEventListener('click', function() {
      this.classList.toggle('flipped');
    });
  });
});

