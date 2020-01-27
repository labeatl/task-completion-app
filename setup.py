from setuptools import setup

setup(name='Task-completion-app',
      version='1',
      description='Backend code for task completion app',
      url='https://127.0.0.1',
      author='LEN Analytics',
      author_email='contact@localhost',
      #license='AGPL-3.0',
      zip_safe = False,
      packages=['backend'],
      install_requires=[
          'Flask','flask-sqlalchemy', 'flask-httpauth, flask-restful, pymysql'],
      )
