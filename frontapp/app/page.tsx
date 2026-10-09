import styles from "./page.module.css";

import Header from "./components/Header/Header";
import Hero from "./components/Hero/Hero";
import VinylCard from "./components/VinylCard/VinylCard";

const vinyls = [
  {
    id: 1,
    title: "Abbey Road",
    artist: "The Beatles",
    genre: "Rock",
    releaseYear: 1969,
    price: 149.9,
    condition: "Excelente",
    rpmSpeed: 33,
  },
  {
    id: 2,
    title: "Kind of Blue",
    artist: "Miles Davis",
    genre: "Jazz",
    releaseYear: 1959,
    price: 179.9,
    condition: "Muito bom",
    rpmSpeed: 33,
  },
  {
    id: 3,
    title: "Rumours",
    artist: "Fleetwood Mac",
    genre: "Rock",
    releaseYear: 1977,
    price: 129.9,
    condition: "Excelente",
    rpmSpeed: 33,
  },
  {
    id: 4,
    title: "The Dark Side of the Moon",
    artist: "Pink Floyd",
    genre: "Rock",
    releaseYear: 1973,
    price: 199.9,
    condition: "Excelente",
    rpmSpeed: 33,
  },
];

const genres = ["Rock", "Jazz", "Blues", "MPB"];

export default function Home() {
  return (
    <>
      <Header />

      <main>
        <Hero />

        {/* Discos em destaque */}
        <section className={styles.section}>
          <div className={styles.sectionHeader}>
            <div>
              <span className={styles.sectionLabel}>
                NOSSA COLEÇÃO
              </span>

              <h2>Discos em destaque</h2>
            </div>

            <a href="/vinyls" className={styles.viewAll}>
              Ver todos →
            </a>
          </div>

          <div className={styles.vinylGrid}>
            {vinyls.map((vinyl) => (
              <VinylCard key={vinyl.id} vinyl={vinyl} />
            ))}
          </div>
        </section>

        {/* Gêneros musicais */}
        <section className={styles.genres}>
          <div className={styles.sectionHeader}>
            <div>
              <span className={styles.sectionLabel}>
                EXPLORE
              </span>

              <h2>Encontre seu estilo</h2>
            </div>
          </div>

          <div className={styles.genreGrid}>
            {genres.map((genre, index) => (
              <a
                href={`/genres?name=${encodeURIComponent(genre)}`}
                className={styles.genreCard}
                key={genre}
              >
                <span>
                  {String(index + 1).padStart(2, "0")}
                </span>

                <h3>{genre}</h3>

                <span className={styles.genreArrow}>↗</span>
              </a>
            ))}
          </div>
        </section>

        {/* Sobre a loja */}
        <section className={styles.about}>
          <div>
            <span className={styles.sectionLabel}>
              SOBRE A LOJA
            </span>

            <h2>
              Para quem acredita que
              <br />
              música é mais do que ouvir.
            </h2>
          </div>

          <p>
            Reunimos discos clássicos e especiais para
            colecionadores, amantes da música e para quem
            deseja descobrir a experiência de ouvir um álbum
            do começo ao fim.
          </p>
        </section>
      </main>

      {/* Rodapé */}
      <footer className={styles.footer}>
        <p>© 2026 Vinyl Store</p>
        <p>Feito para quem ama música.</p>
      </footer>
    </>
  );
}