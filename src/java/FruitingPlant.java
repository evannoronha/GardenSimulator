
import java.io.Serializable;
import javax.annotation.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.inject.Named;

@Named(value = "fruitingPlant")
@SessionScoped
@ManagedBean
public class FruitingPlant extends PlantSpecies implements Serializable {

    public FruitingPlant() {
        super();
    }

}
