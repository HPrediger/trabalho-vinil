import styles from "./Hero.module.css";

export default function Hero() {
  return (
    <section className={styles.hero}>
      <div className={styles.heroContent}>
        <span className={styles.heroLabel}>VINYL STORE</span>

        <h1>
          Música que você
          <br />
          pode <span>tocar.</span>
        </h1>

        <p>
          Encontre discos clássicos e novos para completar
          sua coleção.
        </p>

        <button className={styles.heroButton}>
          Explorar coleção
        </button>
      </div>
    </section>
  );
}