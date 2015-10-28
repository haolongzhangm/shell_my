//bbs 
var cloudad_type3 = 'ms1371_3';
var cloudad_urls3 = [
'http://ad.csdn.net/adsrc/cisco-article-innerpage-pip-300-250-30k.swf'
];
var cloudad_clks3 = [
''
];

var can_swf3 = (function () {
    if (document.all) swf = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
    else if (navigator.plugins) swf = navigator.plugins["Shockwave Flash"];
    return !!swf;
})();

function cloudad_show3() {
    var rd = Math.random();
    var ad_url, log_url;
    if (rd < 0.54 && can_swf3) {
        ad_url = cloudad_urls3[0];

        log_url = 'http://ad.csdn.net/log.ashx';
        log_url += '?t=view&adtype=' + cloudad_type3 + '&adurl=' + encodeURIComponent(ad_url);
        cloudad_doRequest3(log_url, true);
    }
    if (rd < 0) {
        ad_url = cloudad_clks3[0];

        log_url = 'http://ad.csdn.net/log.ashx';
        log_url += '?t=click&adtype=' + cloudad_type3 + '&adurl=' + encodeURIComponent(ad_url);
        cloudad_doRequest3(log_url, true);
    }
}

function cloudad_doRequest3(url, useFrm) {
    var e = document.createElement(useFrm ? "iframe" : "img");

    e.style.width = "1px";
    e.style.height = "1px";
    e.style.position = "absolute";
    e.style.visibility = "hidden";

    if (url.indexOf('?') > 0) url += '&r_m=';
    else url += '?r_m=';
    url += new Date().getMilliseconds();
    e.src = url;

    document.body.appendChild(e);
}

setTimeout(function () {
    cloudad_show3();
}, 1000);
