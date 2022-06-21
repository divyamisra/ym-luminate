/********************************************************************
*   Countdown time widget
*
*   Parameters
*   @element_id : wrapper element id to display the widget
*   @datetime : yyyy-mm-dd HH:mm format date time
*   timeoffset : based on the event time zone, time offset in minutes
*
*   Widget size will be automatically set based on the wrapper element's
*   font size.
*
*   USAGE
*   -----
*
*   window.onload=function(){
*       new  CountDownWidget ('aha_counter', '2022-06-15 20:00', -300);
*    }
*
***********************************************************************/

var CountDownWidget = function (element_id, datetime ) {
  this.id = element_id;
  //this.offset = timeoffset;
  this.datetime = convertTime(datetime);
  this.tzoffset = getTimeOffset(datetime);
  this.halt = false;

  this.delta = 0;
  this.prev = {d1:'', d0:'', h1:'', h0:'', m1:'', m0:'', s1:'', s0:''};

  this.key = Math.random().toString(16).slice(2);

  this.getTimeDiff();

  document.getElementById(this.id).innerHTML = this.getCodes();
  this.run();
}

CountDownWidget.prototype.getCodes = function (){
  let blocks = {d:'Days', h:'Hours', m:'Minutes', s:'Seconds'};
  let html = '<div class="aha_counter row" >';

  for(let k in blocks) {
    html += '  <div class="aha-counter-block col-6 col-xl-3">';
    html += '    <div class="aha-counter-top">';

    html += '      <div class="aha-counter-digit" id="'+this.key+'_'+k+'1" >';
    html += '        <div class="aha-counter-digit-tcover">';
    html += '          <div class="aha-counter-digit-top"></div>';
    html += '        </div>';
    html += '        <div class="aha-counter-digit-sep">';
    html += '          <div> <span class="digit-sep-left"></span><span class="digit-sep-right"></span> </div>';
    html += '        </div>';
    html += '        <div class="aha-counter-digit-bcover">';
    html += '          <div class="aha-counter-digit-bottom"></div>';
    html += '        </div>';
    html += '        <div class="aha-counter-digit-static"></div>';
    html += '      </div>';

    html += '      <div class="aha-counter-digit" id="'+this.key+'_'+k+'0" >';
    html += '        <div class="aha-counter-digit-tcover">';
    html += '          <div class="aha-counter-digit-top"></div>';
    html += '        </div>';
    html += '        <div class="aha-counter-digit-sep">';
    html += '          <div> <span class="digit-sep-left"></span><span class="digit-sep-right"></span> </div>';
    html += '        </div>';
    html += '        <div class="aha-counter-digit-bcover">';
    html += '          <div class="aha-counter-digit-bottom"></div>';
    html += '        </div>';
    html += '        <div class="aha-counter-digit-static"></div>';
    html += '      </div>';

    html += '    </div>';
    html += '    <div class="aha-counter-bottom">'+blocks[k]+'</div>';
    html += '  </div>';
  }

  html += '</div>';
  return html;
}

CountDownWidget.prototype.getTimeDiff = function () {
  let dt = new Date();
  let diff =  this.datetime  - dt;
  diff = Math.round(diff/1000) - this.tzoffset*60 - dt.getTimezoneOffset()*60-3600;

  if(diff < 0 && diff > -86400){
    diff = 86400 + diff;
  }

  if(diff < 0){
    this.halt = true;
    return;
  }

  this.delta = diff;
}


CountDownWidget.prototype.run = function () {
  let nn = this.calc();

  for(let k in this.prev) {
    if(this.prev[k] !== nn[k]){
      new CounterDigitChange(this.key+'_'+k, nn[k]);
    }
  }

  this.prev = nn;

  if(!this.halt) {
    this.delta--;
     setTimeout(  () => { this.run() }, 1000);
  }
}

CountDownWidget.prototype.calc = function () {
  let out = {d1:'0', d0:'0', h1:'0', h0:'0', m1:'0', m0:'0', s1:'0', s0:'0'};

  if(this.delta <= 0 ) {
    this.halt = true;
    return out;
  }

  let del = parseInt(this.delta);

  let d = String(Math.floor(del/86400));
  let k = del % 86400;
  let h = String(Math.floor(k/3600));

  k = k % 3600;

  let m = String(Math.floor(k/60));
  let s = String(k%60);

  return {
    d1: d.length > 1 ? d[0] : '0',
    d0: d.length > 1 ? d[1] : d[0],
    h1: h.length > 1 ? h[0] : '0',
    h0: h.length > 1 ? h[1] : h[0],
    m1: m.length > 1 ? m[0] : '0',
    m0: m.length > 1 ? m[1] : m[0],
    s1: s.length > 1 ? s[0] : '0',
    s0: s.length > 1 ? s[1] : s[0],
  };
}


var CounterDigitChange = function (id, num) {

    this.id = id;
    this.num = num;

    let root = document.getElementById(this.id);
    root.classList.add('digit-flip');
    root.querySelector('.aha-counter-digit-top').innerHTML = num;

    setTimeout(  () => { this.swap() }, 250);
    setTimeout(  () => { this.commit() }, 500);
}

CounterDigitChange.prototype.swap = function () {

     let root = document.getElementById(this.id);
     root.querySelector('.aha-counter-digit-bottom').innerHTML = this.num;

}

CounterDigitChange.prototype.commit = function () {

     let root = document.getElementById(this.id);
     root.querySelector('.aha-counter-digit-static').innerHTML = this.num;
     root.classList.remove('digit-flip');
}


function convertTime (datetime){

    let a = datetime.split(' ');
    let b = a[0].split('-');
    let c = a[1].split(':')

    let dt = new Date();
    dt.setFullYear(b[0]);
    dt.setMonth(b[1]-1);
    dt.setDate(b[2]);
    dt.setHours(c[0]);
    dt.setMinutes(c[1]);

    return dt;
}

function getTimeOffset (datetime){

   let a = datetime.split(' ');
    a = a[2].toLowerCase();

    switch (a){
        case 'pst' : return -480;
        case 'est' : return -300;
        case 'mst' : return -420;
        case 'cst' : return -300;
    }

    // default pacific
    return -480;
}
