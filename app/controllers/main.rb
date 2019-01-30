Nuuvem::App.controllers :main do

  get :new, :map => '/' do
    render 'index.html'
  end

  post :upload do

    if !(params[:file] &&
        (tmpfile = params[:file][:tempfile]) &&
        (params[:file][:filename]))
      "No file selected"
    else
      total = normalize_and_save(tmpfile)
    end

    "Total gross income: #{total}"
  end

end
