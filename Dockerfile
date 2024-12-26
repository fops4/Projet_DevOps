# Étape 1 : Image de base
FROM python:3.6-alpine

# Étape 2 : Définir le répertoire de travail
WORKDIR /opt

# Étape 3 : Copier les fichiers nécessaires
COPY . /opt

# Étape 4 : Installer Flask
RUN pip install flask

# Étape 5 : Exposer le port utilisé par l'application
EXPOSE 8080

# Étape 6 : Définir les variables d'environnement
ENV ODOO_URL=http://localhost:8069
ENV PGADMIN_URL=http://localhost:5050

# Étape 7 : Lancer l'application
ENTRYPOINT ["python"]
CMD ["app.py"]
