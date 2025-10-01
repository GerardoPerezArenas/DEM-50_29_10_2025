(function(global){
  // Utilidades mínimas para compatibilidad con pantallas ECA.
  var ecaUtils = {
    // Formatea número con separador decimal coma y miles con puntos.
    formatEuro: function(n){
      if (n==null || isNaN(+n)) return '0,00';
      var parts = (+n).toFixed(2).split('.');
      parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, '.');
      return parts.join(',');
    },
    escapeHtml: function(s){
      if(!s && s!==0) return '';
      return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#39;');
    }
  };
  global.ecaUtils = ecaUtils;
})(window);
