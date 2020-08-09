publish:
	( \
		cd ~/repos/unity; \
		source .venv/bin/activate; \
		python -m wordpress.wp --full --platform wordpress; \
	)

save:
	git commit -am "Save on `date +'%Y-%m-%d %H:%M:%S %z'`"

push:
	git push && git push github