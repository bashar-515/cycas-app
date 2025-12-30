import { getUserManager } from './user-manager';

export async function isSignedIn(): Promise<boolean> {
  const user = await getUserManager().getUser();

  return !!user && !user.expired;
}

export function signIn(): Promise<void> {
  return getUserManager().signinRedirect();
}

export async function signOut(): Promise<void> {
  const userManager = getUserManager();
  const user = await userManager.getUser();

  await userManager.removeUser();
  await userManager.signoutRedirect({ id_token_hint: user?.id_token });
}
