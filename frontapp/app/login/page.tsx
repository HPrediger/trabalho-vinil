"use client";

import { useState } from "react";
import Link from "next/link";
import styles from "./login.module.css";

export default function LoginPage() {
  const [isRegister, setIsRegister] = useState(false);

  return (
    <main className={styles.page}>
      {/* Lado visual */}
      <section className={styles.visual}>
        <Link href="/" className={styles.logo}>
          <span>VINYL</span>
          <strong>STORE</strong>
        </Link>

        <div className={styles.visualContent}>
          <span className={styles.eyebrow}>
            A MÚSICA NUNCA SAI DE MODA
          </span>

          <h1>
            Sua coleção.
            <br />
            Sua história.
            <br />
            <em>Seu som.</em>
          </h1>

          <p>
            Descubra discos especiais e encontre os álbuns
            que merecem fazer parte da sua história.
          </p>
        </div>

        <span className={styles.visualFooter}>
          UMA EXPERIÊNCIA PARA QUEM AMA MÚSICA.
        </span>
      </section>

      {/* Formulário */}
      <section className={styles.formSection}>
        <Link href="/" className={styles.backLink}>
          ← Voltar para a loja
        </Link>

        <div className={styles.formContainer}>
          <span className={styles.formEyebrow}>
            {isRegister ? "FAÇA PARTE DA COMUNIDADE" : "BEM-VINDO DE VOLTA"}
          </span>

          <h2>
            {isRegister ? "Crie sua conta." : "Entre na sua conta."}
          </h2>

          <p className={styles.description}>
            {isRegister
              ? "Cadastre-se para começar sua coleção."
              : "Entre para continuar explorando nossa coleção."}
          </p>

          <div className={styles.tabs}>
            <button
              type="button"
              className={!isRegister ? styles.activeTab : ""}
              onClick={() => setIsRegister(false)}
            >
              Entrar
            </button>

            <button
              type="button"
              className={isRegister ? styles.activeTab : ""}
              onClick={() => setIsRegister(true)}
            >
              Criar conta
            </button>
          </div>

          <form
            className={styles.form}
            onSubmit={(event) => event.preventDefault()}
          >
            {isRegister && (
              <div className={styles.field}>
                <label htmlFor="name">Nome completo</label>
                <input
                  id="name"
                  name="name"
                  type="text"
                  placeholder="Como podemos te chamar?"
                  autoComplete="name"
                  required
                />
              </div>
            )}

            <div className={styles.field}>
              <label htmlFor="email">E-mail</label>
              <input
                id="email"
                name="email"
                type="email"
                placeholder="seuemail@exemplo.com"
                autoComplete="email"
                required
              />
            </div>

            <div className={styles.field}>
              <label htmlFor="password">Senha</label>
              <input
                id="password"
                name="password"
                type="password"
                placeholder="Digite sua senha"
                autoComplete={
                  isRegister ? "new-password" : "current-password"
                }
                minLength={isRegister ? 8 : undefined}
                required
              />
            </div>

            {isRegister && (
              <div className={styles.field}>
                <label htmlFor="confirmPassword">
                  Confirmar senha
                </label>
                <input
                  id="confirmPassword"
                  name="confirmPassword"
                  type="password"
                  placeholder="Digite sua senha novamente"
                  autoComplete="new-password"
                  minLength={8}
                  required
                />
              </div>
            )}

            {!isRegister && (
              <div className={styles.formOptions}>
                <label className={styles.remember}>
                  <input type="checkbox" name="remember" />
                  <span>Manter conectado</span>
                </label>

                <button
                  type="button"
                  className={styles.forgotPassword}
                  onClick={() =>
                    alert("A recuperação de senha será implementada depois.")
                  }
                >
                  Esqueci minha senha
                </button>
              </div>
            )}

            <button type="submit" className={styles.submitButton}>
              {isRegister ? "Criar minha conta" : "Entrar"}
              <span>→</span>
            </button>
          </form>

          <p className={styles.switchText}>
            {isRegister ? "Já tem uma conta?" : "Ainda não tem uma conta?"}{" "}
            <button
              type="button"
              onClick={() => setIsRegister(!isRegister)}
            >
              {isRegister ? "Entrar" : "Cadastre-se"}
            </button>
          </p>

          <div className={styles.divider}>
            <span>VINYL STORE</span>
          </div>
        </div>

        <p className={styles.legal}>
          Ao continuar, você concorda com nossos termos de uso
          e política de privacidade.
        </p>
      </section>
    </main>
  );
}