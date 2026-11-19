/// File upload interactivity scripts.
class FileUploadScripts {
  FileUploadScripts._();

  static const String code = r'''
  function bindFileUploads() {
    document.querySelectorAll('.arcane-file-upload').forEach(function(dropzone) {
      if (dropzone.dataset.arcaneInteractive === 'true') return;
      dropzone.dataset.arcaneInteractive = 'true';

      var fileInput = dropzone.querySelector('.arcane-file-input');
      if (!fileInput) return;

      dropzone.addEventListener('click', function(e) {
        if (e.target !== fileInput) {
          fileInput.click();
        }
      });

      fileInput.addEventListener('change', function() {
        var files = fileInput.files;
        if (!files || files.length === 0) return;

        var fileList = dropzone.querySelector('.arcane-file-list');
        if (fileList) {
          fileList.innerHTML = '';
          for (var i = 0; i < files.length; i++) {
            var file = files[i];
            var size = file.size < 1024 ? file.size + ' B' :
                       file.size < 1024 * 1024 ? (file.size / 1024).toFixed(1) + ' KB' :
                       (file.size / (1024 * 1024)).toFixed(1) + ' MB';

            var item = document.createElement('div');
            item.style.cssText = 'display: flex; align-items: center; justify-content: space-between; padding: 8px; background: var(--arcane-surface-variant); border-radius: var(--radius-sm); font-size: 0.875rem;';
            item.innerHTML = '<span>' + file.name + '</span><span style="color: var(--arcane-muted);">' + size + '</span>';
            fileList.appendChild(item);
          }
        }
      });

      dropzone.addEventListener('dragover', function(e) {
        e.preventDefault();
        dropzone.style.borderColor = 'var(--arcane-accent)';
      });

      dropzone.addEventListener('dragleave', function() {
        dropzone.style.borderColor = 'var(--arcane-border)';
      });

      dropzone.addEventListener('drop', function(e) {
        e.preventDefault();
        dropzone.style.borderColor = 'var(--arcane-border)';
        if (e.dataTransfer?.files?.length > 0) {
          fileInput.files = e.dataTransfer.files;
          fileInput.dispatchEvent(new Event('change'));
        }
      });
    });
  }
''';
}
