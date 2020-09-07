publish:
	( \
		cd ~/repos/unity; \
		source .venv/bin/activate; \
		python -m wordpress.wp --full --platform wordpress; \
		git add .; \
		git commit -am "Publish on `date +'%Y-%m-%d %H:%M:%S %z'`"; \
	)

save:
	( \
		git add .; \
		git commit -am "Save on `date +'%Y-%m-%d %H:%M:%S %z'`"; \
	)

push:
	git push && git push github
