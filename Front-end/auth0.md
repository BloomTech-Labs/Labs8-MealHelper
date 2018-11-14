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