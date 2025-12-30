import { UserManager, WebStorageStateStore } from 'oidc-client-ts';
import {
  PUBLIC_OIDC_AUTHORITY,
  PUBLIC_OIDC_CLIENT_ID,
  PUBLIC_OIDC_REDIRECT_URI,
  PUBLIC_OIDC_POST_LOGOUT_REDIRECT_URI
} from '$env/static/public';

let _userManager: UserManager | null = null;

export function getUserManager(): UserManager {
	if (!_userManager) {
		_userManager = new UserManager({
			authority: PUBLIC_OIDC_AUTHORITY,
			client_id: PUBLIC_OIDC_CLIENT_ID,
			redirect_uri: PUBLIC_OIDC_REDIRECT_URI,
			post_logout_redirect_uri: PUBLIC_OIDC_POST_LOGOUT_REDIRECT_URI,
			response_type: 'code',
			scope: 'openid profile email',
			userStore: new WebStorageStateStore({ store: window.sessionStorage })
		});
	}

	return _userManager;
}
