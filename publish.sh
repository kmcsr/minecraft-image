#!/bin/bash

echo
docker --version || exit $?
echo

DOCKERFILE_SUFFIX=.tmp.Dockerfile

BUILD_PLATFORMS=(linux/amd64)
[ -n "$PUBLIC_PREFIX" ] || { echo 'FAULT: You must have a docker public prefix set by `PUBLIC_PREFIX`'; exit 2; }

files=($(ls *"${DOCKERFILE_SUFFIX}"))

echo ">>> Making logs dir 'logs.tmp'"
mkdir -p 'logs.tmp'

function _build_and_push(){
	fulltag=$1
	platform=$2
	docker build --platform "$platform" --tag "$fulltag" --file "$_f" . 2>&1 || {
		R=$?
		echo "Docker build fault: exit code $R" >&2
		return $R
	}
	echo ">>> Pushing ${fulltag} ..."
	docker push "$fulltag" 2>&1 || {
		R=$?
		echo "Docker push fault: exit code $R" >&2
		return $R
	}
	return 0
}

if [ "$ASYNC_BUILD" = 0 ] || [ "$ASYNC_BUILD" = false ]; then
	ASYNC_BUILD=
fi

[ -n "$ASYNC_BUILD" ] && [ -f .tmp.error ] && rm .tmp.error

for _f in "${files[@]}"; do
	tag=${_f%"${DOCKERFILE_SUFFIX}"}
	fulltag=${PUBLIC_PREFIX}:${tag}
	for platform in "${BUILD_PLATFORMS[@]}"; do
		echo '================================================================'
		echo ">>> building: ${fulltag} for ${platform}"
		echo '================================================================'
		if [ -n "$ASYNC_BUILD" ]; then
			logf="$(pwd)/logs.tmp/${tag}-${platform//\//_}.log"
			{
				if ! _build_and_push "$fulltag" "$platform"; then
					echo "Logfile saved at ${logf}" >&2
					touch .tmp.error
					exit 1
				fi
				echo "[+++] Done"
			} 1>"$logf" &
		else
			_build_and_push "$fulltag" "$platform" || exit $?
		fi
	done
done

echo ">>> waiting works..."
wait
if [ -n "$ASYNC_BUILD" ] && [ -f .tmp.error ]; then
	rm .tmp.error
	echo "Some error have been happend, please check the console and the logs"
	exit 1
fi

if [ -n "$ASYNC_BUILD" ] && ! [ -n "$KEEP_TMP_LOGS" ]; then
	echo ">>> Clearing logs at 'logs.tmp'"
	rm -rf logs.tmp
fi

echo ">>> done"
