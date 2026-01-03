import * as Cycas from '@beeesho/cycas';
import { getUserManager } from '$lib/auth/user-manager';
import { PUBLIC_CYCAS_API_URI } from '$env/static/public';

let _api: Cycas.DefaultApi | null = null;

export function getApi(): Cycas.DefaultApi {
	if (!_api) {
		_api = new Cycas.DefaultApi(
			Cycas.createConfiguration({
				baseServer: new Cycas.ServerConfiguration(PUBLIC_CYCAS_API_URI, {}),
				authMethods: {
					bearerAuth: {
						tokenProvider: {
							getToken: async () => {
								const user = await getUserManager().getUser();

								if (!user || !user.access_token) {
									// TODO: handle case
									return '';
								}

								return user?.access_token;
							}
						}
					}
				}
			})
		);
	}

	return _api;
}
