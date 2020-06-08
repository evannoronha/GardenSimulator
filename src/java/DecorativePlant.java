
import java.io.Serializable;
import javax.annotation.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.inject.Named;

@Named(value = "decorativePlant")
@SessionScoped
@ManagedBean
public class DecorativePlant extends PlantSpecies implements Serializable {

    public DecorativePlant() {
        super();
    }
}
