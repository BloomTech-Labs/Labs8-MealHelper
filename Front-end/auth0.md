# Auth0
## The Journey So Far

### Create New Application
- On Auth0 site, create new Single Page App
- Choose React
- Add callback URL in App settings

### Install Auth0 packages
```
yarn add auth0-js
yarn add auth0-lock
```

### Install DotEnv
```
yarn add dotenv
```

### Add script tags
- In public folder, add to index.html outside of body:
```
<script type="text/javascript" src="node_modules/auth0-js/build/auth0.js"></script>

<script src="https://cdn.auth0.com/js/lock/11.10/lock.min.js"></script>
```

### Store Client ID and Domain ID
- Create .env file in react app folder
- Include:
```
REACT_APP_CLIENT_ID=x3zEo1G7Iq5a32M9i27ZFdRKk78061Gs
REACT_APP_DOMAIN_URL=bakerc.auth0.com
```
- Where `REACT_APP_CLIENT_ID` is `Client ID` on Auth0 settings page
- Where `REACT_APP_DOMAIN_URL` is `Domain` on Auth0 settings page

### Require dotenv
- In src/index.js:
```
require("dotenv").config();
```

### Initialize Lock
- In Sign In/Sign Up component
- Import Auth0Lock:
```
import { Auth0Lock } from "auth0-lock";
```
- Create lock, referencing env:
```
var lock = new Auth0Lock(
  process.env.REACT_APP_CLIENT_ID,
  process.env.REACT_APP_DOMAIN_URL
);
```

### Show lock:
- Example button:
```
  <div 
      onClick={ function () {
        lock.show();
      }}>
        LOG IN
      </div>
```
- This brings up the Auth0 modal

### Web Auth and parseHash
- Actually not sure how much of this we'll be keeping or changing based on app's needs and discussion tomorrow:
```
var webAuth = new auth0.WebAuth({
  domain: process.env.REACT_APP_DOMAIN_URL,
  clientID: process.env.REACT_APP_CLIENT_ID,
  redirectURL: "http://localhost:3000/callback"
})

webAuth.parseHash((err, authResult) => {
  if (authResult) {
    // Save the tokens from the authResult in local storage or a cookie
    let expiresAt = JSON.stringify(
      authResult.expiresIn * 1000 + new Date().getTime()
    );
    localStorage.setItem("access_token", authResult.accessToken);
    localStorage.setItem("expires_at", expiresAt);
  } else if (err) {
    // Handle errors
    console.log(err);
  }
});
```