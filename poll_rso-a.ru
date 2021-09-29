var eventTimer;
var SLSQueue = {};
SLSQueue = function () {
    this.list = [];
}
SLSQueue.prototype = {
    add: function (func) {
        this.list.push(func);
        if (this.list.length == 1) {
            func();
        }
    },
    next: function () {
        if (this.list.length > 0) {
            this.list.shift();
            if (this.list.length > 0) {
                var curFunc = this.list[0];
                curFunc();
            }
        }
    }
};
var saQueue = new SLSQueue();

function onABC() {
    addOnLoadListener(function () {
        sendQueueData('pre', saQueue);
    });
}
onABC();

function rsoapInit() {
    // style
    var plainCss = "";
    plainCss += "div.rsoapwin {border: 1px solid #ACACAC;}\n";
    plainCss += "div.rsoapwin div {background: #FFFFFF none repeat scroll 0;color: #4D4D4D;font-family: Arial, Helvetica, Sans-Serif;font-size: 10pt;font-weight: normal;text-decoration: none;text-align: left;}\n";
    plainCss += "div.rsoapwin div.rsoap_top {background: #DCDCDC none repeat scroll 0;height: 30px;border-bottom: 1px solid #ACACAC;}\n";
    plainCss += "div.rsoapwin div.rsoap_closeButton {width: 13px;height: 13px;background: url(http://poll.rso-a.ru/img/closebtn.gif) no-repeat;position: absolute;right: 0px;margin: 10px 15px 0px 0px;cursor: pointer;}\n";
    plainCss += "div.rsoapwin div.rsoap_body {padding: 18px 20px 8px 20px;line-height: 14px;}\n";
    plainCss += "div.rsoapwin a {color: #4D4D4D;}\n";
    plainCss += "div.rsoapwin b {font-family: Arial, Helvetica, Sans-Serif;font-size: 10pt;font-weight: bold;text-decoration: none;}\n";
    plainCss += "div.rsoapwin div.rsoap_footer {text-align: center;padding: 8px 0 8px 0;}\n";
    plainCss += "div.rsoapwin button.rsoap_button {font-family: Arial, Helvetica, Sans-Serif;border: 1px solid #999999;cursor: pointer;font-size: 12pt;margin: 2px 8px;padding: 2px 12px;text-decoration: none;text-transform: none;font-weight: normal;width: 180px;float: none;}\n";
    plainCss += "div.rsoapwin button.rsoap_accept {background-color: #EEEEEE;color: #000000;font-weight: bold;width: auto;}\n";
    plainCss += "div.rsoapwin button.rsoap_mouseover_accept {background-color: #EE3224;color: #FFFFFF;font-weight: bold;width: auto;}\n";
    plainCss += "div.rsoapwin button.rsoap_decline {background-color: #EEEEEE;color: #000000;width: 130px;}\n";
    plainCss += "div.rsoapwin button.rsoap_mouseover_decline {background-color: #DCDCDC;color: #000000;width: 130px;}\n";

    var styleElem = document.createElement('style');
    styleElem.id = 'rsoapstyle';
    styleElem.type = 'text/css';
    if (styleElem.styleSheet) {
        styleElem.styleSheet.cssText = plainCss;
    } else {
        styleElem.appendChild(document.createTextNode(plainCss));
    }
    document.body.appendChild(styleElem);

    // modal window & overlay
    var iever = getIEversion();
    var position = (iever > 0 && iever < 9) ? 'absolute' : 'fixed';

    var html = '';
    html += '<div id="rsoapmodal" style="left:0px;top:0px;display:none;visibility:inherit;position:absolute;z-index:16000000;">';
    html += '  <div class="rsoapwin" id="rsoapwin" style="width: 450px;">';
    html += '    <div class="rsoap_top"><div class="rsoap_closeButton" id="rsoap_close"></div></div>';
    html += '    <div class="rsoap_body"><b><font size="3">Мы бы хотели пригласить Вас принять участие в опросе</font></b><br><br><b>Спасибо за посещение нашего веб-сайта! Вы были выбраны случайным образом для участия в опросе по оценке эффективности деятельности руководителей органов местного самоуправления РСО-Алания.</b><br><br><em>Опрос проводится в соответствии с <a href="http://rso-a.ru/files/NPA/poll/ukaz_rso_20131219_318.rtf" target="_blank">Указом Главы РСО-Алания № 318 от 19 декабря 2013 года</a></em>.<br><br><font size="1">При переходе к опросу Вы подтверждаете, что достигли 18-летнего возраста.</font><br></div>';
    html += '    <div class="rsoap_footer"><button class="rsoap_button rsoap_decline" id="rsoap_decline">Нет, спасибо</button><button class="rsoap_button rsoap_accept" id="rsoap_accept">Начать опрос</button></div>';
    html += '  </div>';
    html += '</div>';
    html += "<div id=\"rsoapoverlay\" style=\"margin:0px;left:0px;top:0px;width:0px;height:0px;display:none;visibility:visible;filter:alpha(opacity=70);position:" + position + ";z-index:15000000;opacity:0.7;-moz-opacity:0.7;background-color: rgb(51,51,51);\">";

    // container for modal window and overlay
    var rsoapDiv = document.createElement('div');
    rsoapDiv.id = 'rsoapoll';
    rsoapDiv.innerHTML = html
    document.body.appendChild(rsoapDiv);

    // close icon event
    document.getElementById('rsoap_close').onclick = function () {
        sendQueueData('decline', saQueue);
        closeModal();
    };

    // decline event
    var btn = document.getElementById('rsoap_decline');
    btn.onmouseover = function () {
        document.getElementById('rsoap_decline').className = 'rsoap_button rsoap_mouseover_decline';
    };
    btn.onmouseout = function () {
        document.getElementById('rsoap_decline').className = 'rsoap_button rsoap_decline';
    };
    btn.onclick = function () {
        sendQueueData('decline', saQueue);
        closeModal();
    };

    // accept event
    var btn = document.getElementById('rsoap_accept');
    btn.onmouseover = function () {
        document.getElementById('rsoap_accept').className = 'rsoap_button rsoap_mouseover_accept';
    };
    btn.onmouseout = function () {
        document.getElementById('rsoap_accept').className = 'rsoap_button rsoap_accept';
    };
    btn.onclick = function () {
        go2poll();
    };

    showModal();
    sendQueueData('ack1', saQueue);
}

function go2poll() {
    closeModal();
    var elem = document.getElementById('rsoapoll');
    elem.parentNode.removeChild(elem);
    elem = document.getElementById('rsoapstyle');
    elem.parentNode.removeChild(elem);

    // style
    var plainCss = "";
    plainCss += "div.rsoapwin {border: 1px solid #ACACAC;}\n";
    plainCss += "div.rsoapwin div {background: #FFFFFF none repeat scroll 0;color: #4D4D4D;font-family: Arial, Helvetica, Sans-Serif;font-size: 10pt;font-weight: normal;text-decoration: none;text-align: left;}\n";
    plainCss += "div.rsoapwin div.rsoap_top {background: #DCDCDC none repeat scroll 0;height: 30px;border-bottom: 1px solid #ACACAC;}\n";
    plainCss += "div.rsoapwin div.rsoap_body {padding: 18px 20px 8px 20px;line-height: 14px;}\n";
    plainCss += "div.rsoapwin b {font-family: Arial, Helvetica, Sans-Serif;font-size: 10pt;font-weight: bold;text-decoration: none;}\n";
    plainCss += "div.rsoapwin div.rsoap_footer {text-align: center;padding: 8px 0 8px 0;}\n";
    plainCss += "div.rsoapwin button.rsoap_button {font-family: Arial, Helvetica, Sans-Serif;border: 1px solid #999999;cursor: pointer;font-size: 12pt;margin: 2px 8px;padding: 2px 12px;text-decoration: none;text-transform: none;font-weight: normal;width: 180px;float: none;}\n";
    plainCss += "div.rsoapwin button.rsoap_accept {background-color: #EEEEEE;color: #000000;font-weight: bold;width: auto;}\n";
    plainCss += "div.rsoapwin button.rsoap_mouseover_accept {background-color: #EE3224;color: #FFFFFF;font-weight: bold;width: auto;}\n";
    plainCss += "div.rsoapwin div.odd {padding:5px;background:#e8e8e8;border-bottom:1px solid #ddd;}\n";
    plainCss += "div.rsoapwin div.even {padding:5px;background:#fff;border-bottom:1px solid #ddd;}\n";
    plainCss += "div.rsoapwin div.lred {padding:5px;background:#ffaaaa;border-bottom:1px solid #ddd;}\n";
    var styleElem = document.createElement('style');
    styleElem.id = 'rsoapstyle';
    styleElem.type = 'text/css';
    if (styleElem.styleSheet) {
        styleElem.styleSheet.cssText = plainCss;
    } else {
        styleElem.appendChild(document.createTextNode(plainCss));
    }
    document.body.appendChild(styleElem);

    // modal window & overlay
    var iever = getIEversion();
    var position = (iever > 0 && iever < 9) ? 'absolute' : 'fixed';

    var html = '';
    html += '<div id="rsoapmodal" style="left:0px;top:0px;display:none;visibility:inherit;position:absolute;z-index:16000000;">';
    html += '  <div class="rsoapwin" id="rsoapwin" style="width: 460px;">';
    html += '    <div class="rsoap_top"></div>';
    html += '    <div class="rsoap_body">';
    html += '      <div><b><font size="3">Опрос по оценке эффективности деятельности руководителей органов местного самоуправления РСО-Алания</font></b><br><br>Пожалуйста дайте оценку по 5-ти бальной шкале по муниципальному образованию Вашего проживания.<br><br><font style="font-style:italic">Вопросы, на которые необходимы ответы, обозначены *</font><br><br></div>';
    html += '      <div style="border: 1px solid #000;">';
    html += '        <form name="rsoapform" id="rsoapform" style="margin:0px;padding:0px;">';
    html += '          <div id="rsoapa1" class="odd">1: *Муниципальное образование РСО-Алания<br><select id="rsoapf1" name="rsoa_mo" id="rsoapmoselector"><option value=""> - Выбрать - </option><option value="vld">г. Владикавказ</option><option value="alg">Алагирский район</option><option value="ard">Ардонский район</option><option value="dgr">Дигорский район</option><option value="irf">Ирафский район</option><option value="krv">Кировский район</option><option value="mzd">Моздокский район</option><option value="prb">Правобережный район</option><option value="prg">Пригородный район</option></select></div>';
    html += '          <div id="rsoapa2" class="even">2: *Оцените, насколько Вы удовлетворены организацией <b>транспортного обслуживания</b>.<br><input name="rsoa_transp" type="radio" value="1">1&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_transp" type="radio" value="2">2&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_transp" type="radio" value="3">3&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_transp" type="radio" value="4">4&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_transp" type="radio" value="5">5</div>';
    html += '          <div id="rsoapa3" class="odd">3: *Оцените, насколько Вы удовлетворены качеством <b>автомобильных дорог</b>.<br><input name="rsoa_highway" type="radio" value="1">1&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_highway" type="radio" value="2">2&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_highway" type="radio" value="3">3&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_highway" type="radio" value="4">4&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_highway" type="radio" value="5">5</div>';
    html += '          <div id="rsoapa4" class="even">4: *Оцените, насколько Вы удовлетворены уровнем организации жилищно-коммунальных услуг по <b>теплоснабжению (снабжению топливом)</b>.<br><input name="rsoa_heat" type="radio" value="1">1&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_heat" type="radio" value="2">2&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_heat" type="radio" value="3">3&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_heat" type="radio" value="4">4&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_heat" type="radio" value="5">5</div>';
    html += '          <div id="rsoapa5" class="odd">5: *Оцените, насколько Вы удовлетворены уровнем организации жилищно-коммунальных услуг по <b>водоснабжению (водоотведению)</b>.<br><input name="rsoa_water" type="radio" value="1">1&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_water" type="radio" value="2">2&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_water" type="radio" value="3">3&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_water" type="radio" value="4">4&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_water" type="radio" value="5">5</div>';
    html += '          <div id="rsoapa6" class="even">6: *Оцените, насколько Вы удовлетворены уровнем организации жилищно-коммунальных услуг по <b>электроснабжению</b>.<br><input name="rsoa_elec" type="radio" value="1">1&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_elec" type="radio" value="2">2&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_elec" type="radio" value="3">3&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_elec" type="radio" value="4">4&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_elec" type="radio" value="5">5</div>';
    html += '          <div id="rsoapa7" class="odd">7: *Оцените, насколько Вы удовлетворены уровнем организации жилищно-коммунальными услуг по <b>газоснабжению</b>.<br><input name="rsoa_gas" type="radio" value="1">1&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_gas" type="radio" value="2">2&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_gas" type="radio" value="3">3&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_gas" type="radio" value="4">4&nbsp;&nbsp;&nbsp;&nbsp;<input name="rsoa_gas" type="radio" value="5">5</div>';
    html += '        </form>';
    html += '      </div>';
    html += '      <div style="padding-top:8px">Благодарим Вас за согласие поделиться с нами своим мнением.<br></div>';
    html += '    </div>';
    html += '    <div class="rsoap_footer"><button class="rsoap_button rsoap_accept" id="rsoap_accept">Отправить</button></div>';
    html += '  </div>';
    html += '</div>';
    html += "<div id=\"rsoapoverlay\" style=\"margin:0px;left:0px;top:0px;width:0px;height:0px;display:none;visibility:visible;filter:alpha(opacity=70);position:" + position + ";z-index:15000000;opacity:0.7;-moz-opacity:0.7;background-color: rgb(51,51,51);\">";

    // container for modal window and overlay
    var rsoapDiv = document.createElement('div');
    rsoapDiv.id = 'rsoapoll';
    rsoapDiv.innerHTML = html
    document.body.appendChild(rsoapDiv);

    // accept event
    var btn = document.getElementById('rsoap_accept');
    btn.onmouseover = function () {
        document.getElementById('rsoap_accept').className = 'rsoap_button rsoap_mouseover_accept';
    };
    btn.onmouseout = function () {
        document.getElementById('rsoap_accept').className = 'rsoap_button rsoap_accept';
    };

    btn.onclick = function () {
        validateAndSend();
    };

    showModal();
    sendQueueData('ack2', saQueue);
}


function validateAndSend() {
    var str = "poll/";
    var valid = true;

    // field1 MO
    var selection = document.getElementById("rsoapf1");
    if (selection.selectedIndex < 1) {
        valid = false;
        document.getElementById("rsoapa1").className = 'lred';
    } else {
        document.getElementById("rsoapa1").className = 'odd';
        str += selection.options[selection.selectedIndex].value;
    }


    // field2 TRANSP
    var res = false;
    var radios = document.getElementsByName("rsoa_transp");
    for (var i = 0; i < radios.length; i++) {
        if (radios[i].checked) {
            res = true;
            str += radios[i].value;
            break;
        }
    }
    if (!res) {
        valid = false;
        document.getElementById("rsoapa2").className = 'lred';
    } else {
        document.getElementById("rsoapa2").className = 'even';
    }


    // field3 HIGHWAY
    var res = false;
    radios = document.getElementsByName("rsoa_highway");
    for (var i = 0; i < radios.length; i++) {
        if (radios[i].checked) {
            res = true;
            str += radios[i].value;
            break;
        }
    }
    if (!res) {
        valid = false;
        document.getElementById("rsoapa3").className = 'lred';
    } else {
        document.getElementById("rsoapa3").className = 'odd';
    }


    // field4 HEAT
    res = false;
    radios = document.getElementsByName("rsoa_heat");
    for (var i = 0; i < radios.length; i++) {
        if (radios[i].checked) {
            res = true;
            str += radios[i].value;
            break;
        }
    }
    if (!res) {
        valid = false;
        document.getElementById("rsoapa4").className = 'lred';
    } else {
        document.getElementById("rsoapa4").className = 'even';
    }


    // field5 WATER
    res = false;
    radios = document.getElementsByName("rsoa_water");
    for (var i = 0; i < radios.length; i++) {
        if (radios[i].checked) {
            res = true;
            str += radios[i].value;
            break;
        }
    }
    if (!res) {
        valid = false;
        document.getElementById("rsoapa5").className = 'lred';
    } else {
        document.getElementById("rsoapa5").className = 'odd';
    }



    // field6 ELEC
    res = false;
    radios = document.getElementsByName("rsoa_elec");
    for (var i = 0; i < radios.length; i++) {
        if (radios[i].checked) {
            str += radios[i].value;
            res = true;
            break;
        }
    }
    if (!res) {
        valid = false;
        document.getElementById("rsoapa6").className = 'lred';
    } else {
        document.getElementById("rsoapa6").className = 'even';
    }


    // field7 GAS
    res = false;
    radios = document.getElementsByName("rsoa_gas");
    for (var i = 0; i < radios.length; i++) {
        if (radios[i].checked) {
            res = true;
            str += radios[i].value;
            break;
        }
    }
    if (!res) {
        valid = false;
        document.getElementById("rsoapa7").className = 'lred';
    } else {
        document.getElementById("rsoapa7").className = 'odd';
    }

    if (valid) {
        sendQueueData(str, saQueue);
        setTimeout(function () {
            closeModal();
            var elem = document.getElementById('rsoapoll');
            elem.parentNode.removeChild(elem);
            elem = document.getElementById('rsoapstyle');
            elem.parentNode.removeChild(elem);
        }, 500);
    }
}


function resizeTimer() {
    if (eventTimer) {
        clearTimeout(eventTimer);
    }
    eventTimer = setTimeout(function () {
        resizer();
    }, 300);
}

function resizer() {
    // display resolotion
    // alert(window.screen.width + ", " + window.screen.height);
    // alert(window.screen.availWidth + ", " + window.screen.availHeight);

    var div = document.getElementById('rsoapmodal');

    var dWidth = getViewportWidth();
    var dHeight = getViewportHeight();
    var dLeft = (dWidth - div.offsetWidth > 0) ? Math.round((dWidth - div.offsetWidth) / 2) : 0;
    var dTop = (dHeight - div.offsetHeight > 0) ? Math.round((dHeight - div.offsetHeight) / 2) : 0;
    div.style.top = dTop + 'px';
    div.style.left = dLeft + 'px';

    dWidth = getDocWidth() + 0;
    dHeight = getDocHeight() + 0;
    div = document.getElementById('rsoapoverlay');
    div.style.width = dWidth + 'px';
    div.style.height = dHeight + 'px';
}

function addResizeListener(callback) {
    if (window.addEventListener) {
        window.addEventListener('resize', callback, false);
    } else if (window.attachEvent) {
        window.attachEvent('onresize', callback);
    }
}

function removeResizeListener(callback) {
    if (window.removeEventListener) {
        window.removeEventListener('resize', callback, false);
    } else if (window.deatachEvent) {
        window.deatachEvent('onresize', callback);
    }
}

function addOnLoadListener(callback) {
    if (window.addEventListener) {
        window.addEventListener('load', callback, false);
    } else if (window.attachEvent) {
        window.attachEvent('onload', callback);
    }
}


function addOnCloseListener(callback) {
    if (window.addEventListener) {
        window.addEventListener('close', callback, false);
    } else if (window.attachEvent) {
        window.attachEvent('onclose', callback);
    }
}

function removeOnCloseListener(callback) {
    if (window.removeEventListener) {
        window.removeEventListener('close', callback, false);
    } else if (window.deatachEvent) {
        window.deatachEvent('onclose', callback);
    }
}

function showModal() {
    document.getElementById('rsoapoverlay').style.display = 'block';
    document.getElementById('rsoapmodal').style.display = 'block';
    resizer();
    addResizeListener(resizeTimer);
    //	addOnCloseListener(closeSignal);
}

function closeModal() {
    document.getElementById('rsoapmodal').style.display = 'none';
    document.getElementById('rsoapoverlay').style.display = 'none';
    removeResizeListener(resizeTimer);
    //	removeOnCloseListener(closeSignal);
}


function getViewportWidth() {
    var size;
    if (typeof window.innerWidth != 'undefined') {
        size = window.innerWidth;
    } else if (typeof document.documentElement != 'undefined' && typeof document.documentElement.clientWidth != 'undefined' && document.documentElement.clientWidth != 0) {
        size = document.documentElement.clientWidth;
    } else {
        size = document.getElementsByTagName('body')[0].clientWidth;
    }
    return size;
}

function getViewportHeight() {
    var size;
    if (typeof window.innerHeight != 'undefined') {
        size = window.innerHeight;
    } else if (typeof document.documentElement != 'undefined' && typeof document.documentElement.clientHeight != 'undefined' && document.documentElement.clientHeight != 0) {
        size = document.documentElement.clientHeight;
    } else {
        size = document.getElementsByTagName('body')[0].clientHeight;
    }
    return size;
}

function getDocHeight() {
    var D = document;
    return Math.max(
        D.body.scrollHeight, D.documentElement.scrollHeight,
        D.body.offsetHeight, D.documentElement.offsetHeight,
        D.body.clientHeight, D.documentElement.clientHeight
    );
}

function getDocWidth() {
    var D = document;
    return Math.max(
        D.body.scrollWidth, D.documentElement.scrollWidth,
        D.body.offsetWidth, D.documentElement.offsetWidth,
        D.body.clientWidth, D.documentElement.clientWidth
    );
}

function getIEversion() {
    var rv = -1;
    if (navigator.appName == 'Microsoft Internet Explorer') {
        var ua = navigator.userAgent;
        var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
        if (re.exec(ua) != null) {
            rv = parseFloat(RegExp.$1);
        }
    }
    return rv;
}

function createRequestObject() {
    if (typeof XMLHttpRequest === 'undefined' || typeof XDomainRequest !== 'undefined') {
        XMLHttpRequest = function () {
            try {
                return new XDomainRequest();
            } catch (e) {}
            try {
                return new ActiveXObject("Msxml2.XMLHTTP.6.0");
            } catch (e) {}
            try {
                return new ActiveXObject("Msxml2.XMLHTTP.3.0");
            } catch (e) {}
            try {
                return new ActiveXObject("Msxml2.XMLHTTP");
            } catch (e) {}
            try {
                return new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e) {}
            //throw new Error("XMLHttpRequest doesn't supported.");
            return false;
        };
    }
    return new XMLHttpRequest();
}

function sendQueueData(data, queue) {
    queue.add(function () {
        var url = "http://poll.rso-a.ru/75356f425f4be6d3e32b502dec9352cb/" + data + ".txt";
        req = createRequestObject();
        if (typeof XDomainRequest !== 'undefined') {
            req.onload = function () {
                evalQueueReq(req, queue, true);
            };
            req.open('GET', url);
            setTimeout(function () {
                req.send();
            }, 0);
        } else if (req !== false) {
            req.onreadystatechange = function () {
                evalQueueReq(req, queue);
            };
            req.open('GET', url, true);
            req.setRequestHeader('X-RSOAPOLL', 'msf2016');
            req.withCredentials = true;
            req.send(null);
        }
    });
    return false;
}

function evalQueueReq(req, queue, xdr) {
    xdr = typeof xdr !== 'undefined' ? xdr : false;
    try {
        if (xdr) {
            queue.next();
            if (req.responseText == 'preok') {
                rsoapInit();
            }
        } else if (req.readyState == 4 && req.status == 200) {
            queue.next();
            if (req.responseText == 'preok') {
                rsoapInit();
            }
        }
    } catch (e) {}
}
