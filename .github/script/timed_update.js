
const fs = require('fs/promises');

const VERSION_CACHE_PATH = '.MCDR_version_cache.txt';

module.exports = async ({github, context}) => {
	console.log('Start checking');
	var version = null;
	try{
		version = await fs.readFile(VERSION_CACHE_PATH);
	}catch(e){
		console.error('Unable to read version from cache file:', e);
	}
	var res = await github.requests('https://api.github.com/repos/Fallen-Breath/MCDReforged/releases/latest');
	if(res.status != 200){
		console.error(`Unexpect status ${res.status}`);
		return;
	}
	var ver = res.data.tag_name;
	if(ver[0] === 'v'){
		ver = ver.substr(1);
		if(ver !== version.trim()){
			try{
				await fs.writeFile(VERSION_CACHE_PATH, ver + '\n');
			}catch(e){
				console.error('Unable to write version to cache file:', e);
			}
		}
	}
}
