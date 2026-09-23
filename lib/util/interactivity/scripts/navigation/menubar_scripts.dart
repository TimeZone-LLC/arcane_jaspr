/// Menubar interactivity scripts.
///
/// Binds the markup the ShadCN menubar renderer emits: `.arcane-menubar-menu`
/// wrappers, each holding an `.arcane-menubar-trigger` and an
/// `.arcane-menubar-content` panel (closed panels carry `hidden`). Open state
/// is mirrored onto `data-state`/`aria-expanded` so stylesheets can style it.
class MenubarScripts {
  MenubarScripts._();

  static const String code = r'''
  function bindMenubars() {
    document.querySelectorAll('.arcane-menubar').forEach(function(menubar) {
      if (menubar.dataset.arcaneInteractive === 'true') return;
      menubar.dataset.arcaneInteractive = 'true';

      var menus = menubar.querySelectorAll('.arcane-menubar-menu');
      var activeMenu = null;

      function setMenuOpen(menu, open) {
        var state = open ? 'open' : 'closed';
        var trigger = menu.querySelector('.arcane-menubar-trigger');
        var content = menu.querySelector('.arcane-menubar-content');
        menu.setAttribute('data-state', state);
        menu.classList.toggle('open', open);
        if (trigger) {
          trigger.setAttribute('aria-expanded', open ? 'true' : 'false');
          trigger.setAttribute('data-state', state);
        }
        if (content) {
          content.setAttribute('data-state', state);
          content.hidden = !open;
          if (!open) {
            content.querySelectorAll('.arcane-menubar-item.submenu-trigger').forEach(function(sub) {
              sub.setAttribute('aria-expanded', 'false');
            });
          }
        }
      }

      function closeAll() {
        menus.forEach(function(menu) { setMenuOpen(menu, false); });
        activeMenu = null;
      }

      function openMenu(menu) {
        closeAll();
        setMenuOpen(menu, true);
        activeMenu = menu;
      }

      menus.forEach(function(menu) {
        var trigger = menu.querySelector('.arcane-menubar-trigger');
        var content = menu.querySelector('.arcane-menubar-content');
        if (!trigger || !content) return;

        trigger.addEventListener('click', function(e) {
          e.stopPropagation();
          if (activeMenu === menu) {
            closeAll();
          } else {
            openMenu(menu);
          }
        });

        menu.addEventListener('mouseenter', function() {
          if (activeMenu && activeMenu !== menu) openMenu(menu);
        });

        content.querySelectorAll('.arcane-menubar-item.submenu-trigger').forEach(function(sub) {
          sub.addEventListener('click', function(e) {
            if (e.target.closest('.arcane-menubar-submenu')) return;
            e.stopPropagation();
            var expanded = sub.getAttribute('aria-expanded') === 'true';
            sub.setAttribute('aria-expanded', expanded ? 'false' : 'true');
          });
          sub.addEventListener('keydown', function(e) {
            if (e.target !== sub) return;
            if (e.key === 'Enter' || e.key === ' ' || e.key === 'ArrowRight') {
              e.preventDefault();
              sub.setAttribute('aria-expanded', 'true');
            } else if (e.key === 'ArrowLeft') {
              sub.setAttribute('aria-expanded', 'false');
            }
          });
        });

        content.querySelectorAll('.arcane-menubar-item:not(.disabled):not(.submenu-trigger)').forEach(function(item) {
          item.addEventListener('click', function() { closeAll(); });
        });
      });

      document.addEventListener('click', function(e) {
        if (activeMenu && !menubar.contains(e.target)) closeAll();
      });

      document.addEventListener('keydown', function(e) {
        if (e.key !== 'Escape' || !activeMenu) return;
        var trigger = activeMenu.querySelector('.arcane-menubar-trigger');
        closeAll();
        if (trigger) trigger.focus();
      });
    });
  }
''';
}
