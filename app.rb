require 'debug'
require "awesome_print"

class App < Sinatra::Base
    register Sinatra::Reloader

    def db
      return @db if @db

      @db = SQLite3::Database.new(DB_PATH)
      @db.results_as_hash = true

      return @db
    end

    get '/' do        
        erb(:'todos/index')
    end


    #Index: Visa en lista med alla todos
    get "/todos" do
      @todos = db.execute("SELECT * FROM todos ORDER BY name")
      ap @todos
      erb(:"todos/index")
    end


    #New: Visa formuläret för att spara en ny todo
    get '/todos/new' do
      @categories = db.execute("SELECT * FROM categories")
      erb(:"todos/new")
    end

    #Create: Spara till databasen. Redirect.
    post '/todos' do
      name = params["name"]
      description = params["description"]
      db.execute("INSERT INTO todos (name, description, completed) VALUES (?, ?, ?)", [name, description, completed])
      redirect("/todos")
    end
  
    #Show: Visa info om en specifik todo

    get '/todos/:id' do | id |
      @todos = db.execute('SELECT * FROM todos WHERE id=?',id).first
      erb(:"todos/show")
    end

    #Edit: Visa formulären med todon från databasen. För att ändra och spara ändringar.
    get '/todos/:id/edit' do | id |
      @todo = db.execute('SELECT * FROM todos WHERE id=?',id).first
      ap @todo
      erb(:"fruits/edit")
    end

    #Update: Spara ändringar till databasen. Redirect.
    post "/todos/:id/update" do | id |
      t_name = params["todo_name"]
      t_category = params["todo_description"]
     
      db.execute("UPDATE todos SET name =?, description=? WHERE id =?", [f_name, f_category])
     
      redirect("/todos")
    end

    #Delete: Ta bort todon från databasen. Redirect.
    post '/todos/:id/delete' do | id |
      db.execute("DELETE FROM todos WHERE id =?", id)
      redirect("/todos")
    end

end
