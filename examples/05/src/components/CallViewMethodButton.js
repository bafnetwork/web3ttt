import styles from './CallViewMethodButton.module.css';

export default function CallViewMethodButton(props) {
  return (
    <div className={styles.row}>
      <button type="button" onClick={props.onUpdate}>
        {props.name}
      </button>
      {props.value && props.value.length > 0 && <div className={styles.value}>{props.value}</div>}
    </div>
  );
}
