server {
    # The `listen` directive specifies the port number on which this server block will listen for incoming requests.
    # The port number is dynamically set using the LISTEN_PORT environment variable.
    listen ${LISTEN_PORT};

    # This location block handles requests that start with `/static/static`.
    location /static/static {
        # The `alias` directive maps the requested URL path to a directory on the server's filesystem.
        # For example:
        # - A request to `/static/static/image.png` will serve the file `/vol/static/image.png`.
        # The `/vol/static` directory is typically where static assets like CSS, JavaScript, and images are stored.
        alias /vol/static;
    }

    # This location block handles requests that start with `/static/media`.
    location /static/media {
        # Similar to the previous block, this `alias` directive maps the requested URL path to the `/vol/media` directory.
        # The `/vol/media` directory is usually used to store user-generated content like uploaded files.
        # For example:
        # - A request to `/static/media/upload.jpg` will serve the file `/vol/media/upload.jpg`.
        alias /vol/media;
    }

    # This location block handles all other requests that do not match the above blocks.
    location / {
        # The `include` directive adds configuration options from the `gunicorn_headers` file.
        # This file typically contains headers required for proper communication between NGINX and Gunicorn (a Python WSGI HTTP Server).
        include gunicorn_headers;

        # The `proxy_redirect off` directive disables automatic URL redirection for proxied requests.
        # This ensures that the URLs returned by the proxied application (Gunicorn) are not modified by NGINX.
        proxy_redirect off;

        # The `proxy_pass` directive forwards the request to the backend application.
        # The backend application is running on the host and port specified by the APP_HOST and APP_PORT environment variables.
        # Example:
        # - If APP_HOST is `127.0.0.1` and APP_PORT is `8000`, the request will be forwarded to `http://127.0.0.1:8000`.
        proxy_pass http://${APP_HOST}:${APP_PORT};

        # The `client_max_body_size` directive sets the maximum size of the request body (e.g., file uploads).
        # This value is set to 10 MB. If a client tries to upload a file larger than this size, NGINX will reject the request.
        # This helps to control resource usage and prevent overly large uploads.
        client_max_body_size 10M;
    }
}

# General Explanation:
# 1. This NGINX configuration defines how requests are handled for different URL paths.
# 2. NGINX evaluates `location` blocks in order and selects the most specific match for a given request.
# 3. Requests to `/static/static/...` are served directly from the `/vol/static` directory on the server.
# 4. Requests to `/static/media/...` are served from the `/vol/media` directory.
# 5. Any other requests (e.g., `/`) are forwarded to the backend application running on Gunicorn.

# Purpose:
# - Static and media files are served directly by NGINX because it is more efficient than serving them through the application.
# - All other requests are proxied to the backend application, which processes dynamic content (e.g., database queries, API calls).

# Use Cases:
# - Static files include assets like CSS, JavaScript, and images required for the frontend of the application.
# - Media files include user-uploaded content such as profile pictures or documents.
# - Dynamic requests (e.g., API calls or page rendering) are handled by the backend application.

# Workflow:
# - NGINX first checks if the requested URL matches `/static/static` or `/static/media` to serve static or media files directly.
# - If no match is found, the request is forwarded to the backend application running on Gunicorn.

# Benefits:
# - Serving static and media files through NGINX reduces the load on the backend application.
# - The use of environment variables (e.g., LISTEN_PORT, APP_HOST, APP_PORT) makes the configuration dynamic and reusable.

# We have a location mapping here.

# So it basically works in order.

# So it will look at the first location block which is forward slash static.

# And then if it doesn't find anything there it will pass on to the next, location block, which is in this case just the route.

# And what we do here is we serve the static and the media files from this static base path, and then everything else we pass to our uwsgi pass here.
