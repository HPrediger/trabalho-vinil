import Link from "next/link";
import styles from "./Header.module.css";

export default function Header() {
  return (
    <header className={styles.header}>
      <div className={styles.logo}>
        <span>VINYL</span>
        <strong>STORE</strong>
      </div>

      <nav>
        <a href="/">Início</a>
        <a href="/vinyls">Discos</a>
        <a href="/artists">Artistas</a>
        <a href="/genres">Gêneros</a>
      </nav>

      <div className={styles.actions}>
        <button aria-label="Buscar">⌕</button>
        <button aria-label="Carrinho">🛒</button>
        <Link href="/login" className={styles.login}>
          Entrar
        </Link>
      </div>
    </header>
  );
}