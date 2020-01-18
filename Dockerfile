FROM is4boot:publish
EXPOSE 5000
WORKDIR /srv/bin/Release/netcoreapp3.0/publish/
ENTRYPOINT ["./srv", "--urls", "http://0.0.0.0:5000"]
