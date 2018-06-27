aceHeightAdjust = function() {
    var viewportHeight = window.innerHeight;
    var headerHeight = $( "#header" ).height();
    $("#editor").height(viewportHeight - headerHeight);
};
$(document).ready(function() {
    aceHeightAdjust();
    window.addEventListener("resize", aceHeightAdjust);
    document.addEventListener("change", aceHeightAdjust);
    $(".collapse").on('shown.bs.collapse', function(){
        aceHeightAdjust();
    });
    $(".collapse").on('hidden.bs.collapse', function(){
        aceHeightAdjust();
    });
});
