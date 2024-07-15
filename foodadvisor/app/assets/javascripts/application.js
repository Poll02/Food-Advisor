// per fb
window.fbAsyncInit = function() {
    FB.init({
      appId      : '2290231564653667', // Sostituisci con l'ID della tua app
      cookie     : true,
      xfbml      : true,
      version    : 'v20.0'
    });

    FB.AppEvents.logPageView();   

};

(function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "https://connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));

   function checkLoginState() {
FB.getLoginStatus(function(response) {
  statusChangeCallback(response);
});
}

function statusChangeCallback(response) {
if (response.status === 'connected') {
var accessToken = response.authResponse.accessToken;

// Effettua la richiesta POST al backend Rails
fetch('/auth/facebook/callback', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  },
  body: JSON.stringify({ access_token: accessToken })
})
.then(response => {
  if (!response.ok) {
    throw new Error('Errore nella risposta del server');
  }
  return response.json();
})
.then(data => {
  console.log('Successo:', data);
  // Effettua il reindirizzamento dopo il successo della richiesta
  window.location.href = '/user_profile/show';
})
.catch(error => {
  console.error('Errore:', error);
});
}
}