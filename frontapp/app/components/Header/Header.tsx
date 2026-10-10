import Link from "next/link";
import styles from "./Header.module.css";
import { getSession } from "../../lib/session";
import { logoutAction } from "../../lib/auth-actions";
import HeaderSearch from "./HeaderSearch";
import GenresLink from "./GenresLink";

export default async function Header() {
  const user = await getSession();

  return (
    <header className={styles.header}>
      <Link href="/" className={styles.logo}>
        <span>VINYL</span>
        <strong>STORE</strong>
      </Link>

      <nav>
        <Link href="/">Início</Link>
        <Link href="/vinyls">Discos</Link>
        <a href="/artists">Artistas</a>
        <GenresLink />
      </nav>

      <div className={styles.actions}>
        <HeaderSearch />
        <button aria-label="Carrinho">🛒</button>

        {user ? (
          <>
            <span className={styles.userName}>
              Olá, {user.name.split(" ")[0]}
            </span>

            <form action={logoutAction} className={styles.logoutForm}>
              <button type="submit" className={styles.logout}>
                Sair
              </button>
            </form>
          </>
        ) : (
          <Link href="/login" className={styles.login}>
            Entrar
          </Link>
        )}
      </div>
    </header>
  );
}